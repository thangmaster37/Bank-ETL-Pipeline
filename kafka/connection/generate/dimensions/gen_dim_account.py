from faker import Faker
import pandas as pd
import random
import decimal

# Khởi tạo đối tượng Faker
fake = Faker(['en_US'])

def generate_10_digit_string_with_faker():
    # Sử dụng Faker để tạo một chữ số đầu tiên từ 1 đến 9
    first_digit = str(random.randint(1, 9))
    
    # Sử dụng Faker để tạo 9 chữ số tiếp theo
    remaining_digits = fake.unique.numerify(text='#########')
    
    # Kết hợp chữ số đầu tiên với các chữ số còn lại
    return first_digit + remaining_digits

# Hàm để tạo dữ liệu giả cho bảng DimAccount
def generate_dimaccount_records(n):
    records = []
    for account_id in range(1, n + 1):
        account_number = generate_10_digit_string_with_faker()
        customer_id = random.randint(1, 100)
        account_type = random.choice(['Savings', 'Checking', 'Loan', 'Investment'])
        account_balance = round(decimal.Decimal(random.uniform(1000.00, 1000000.00)), 2)
        credit_score = random.randint(200, 850)
        records.append([
            account_id, account_number, customer_id, account_type, account_balance, credit_score
        ])
    return records

# Tạo DataFrame
columns = [
    'account_id', 'account_number', 'customer_id', 'account_type', 
    'account_balance', 'credit_score'
]
account_data = generate_dimaccount_records(150)
df = pd.DataFrame(account_data, columns=columns)

# Ghi dữ liệu vào file CSV
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_accounts.csv', index=False)
