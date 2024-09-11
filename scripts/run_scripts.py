import snowflake.connector
import configparser
from pathlib import Path
import re

config = configparser.ConfigParser()
config.read_file(open(f"{Path(__file__).parents[0]}/snowflake_config.cfg"))

# Các thông số để kết nối đến Snowflake
user = config.get('SNOWFLAKE', 'USER')
password = config.get('SNOWFLAKE', 'PASSWORD')
account = config.get('SNOWFLAKE', 'ACCOUNT')
warehouse = config.get('SNOWFLAKE', 'WAREHOUSE')


# Thiết lập kết nối Snowflake
conn = snowflake.connector.connect(
    user=user,
    password=password,
    account=account,
    warehouse=warehouse
)


# Hàm để làm sạch câu lệnh SQL, loại bỏ comment và dòng trống
def clean_sql_content(sql_content):
    # Loại bỏ comment nhiều dòng /* ... */
    sql_content = re.sub(r'/\*.*?\*/', '', sql_content, flags=re.DOTALL)
    # Loại bỏ comment một dòng -- ...
    sql_content = re.sub(r'--.*', '', sql_content)
    # Tách câu lệnh bằng dấu chấm phẩy, loại bỏ các dòng trống và khoảng trắng thừa
    statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]
    return statements


def run_sql_script(file_path):
    with open(file_path, 'r') as file:
        sql_commands = file.read()  # Đọc toàn bộ nội dung của file SQL

    # Tạo cursor và thực thi các câu lệnh SQL
    cursor = conn.cursor()
    try:
        statements = clean_sql_content(sql_commands)
        for statement in statements:
            cursor.execute(statement)
            print("SQL script executed successfully!")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        cursor.close()

# Chạy file SQL từ thư mục scripts
run_sql_script('scripts/create_snowflake_objects.sql')

# Đóng kết nối
conn.close()
