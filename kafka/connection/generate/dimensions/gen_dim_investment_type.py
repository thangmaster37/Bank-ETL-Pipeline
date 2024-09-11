from faker import Faker
import pandas as pd
import random
import decimal

# Khởi tạo đối tượng Faker
fake = Faker(['en_US'])


# Hàm để tạo dữ liệu giả cho bảng DimInvestmentType
def generate_diminvestmenttype_records():
    records = [[1,"Key Investment"], [2, "Happen Investment"], [3, "Nation Investment"], [4, "Power Investment"], [5, "Special Investment"]]
    return records

# Tạo DataFrame
columns = [
    'investment_type_id', 'investment_type_name'
]
investment_type_data = generate_diminvestmenttype_records()
df = pd.DataFrame(investment_type_data, columns=columns)

# Ghi dữ liệu vào file CSV
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_investment_types.csv', index=False)
