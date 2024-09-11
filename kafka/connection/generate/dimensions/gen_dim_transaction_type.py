from faker import Faker
import pandas as pd
import random
import decimal

# Khởi tạo đối tượng Faker
fake = Faker(['en_US'])


# Hàm để tạo dữ liệu giả cho bảng DimTransactionType
def generate_dimtransactiontype_records():
    records = [[1,"Deposit"], [2, "Withdrawal"], [3, "Transfer"], [4, "Payment"]]
    return records

# Tạo DataFrame
columns = [
    'transaction_type_id', 'transaction_type_name'
]
transaction_type_data = generate_dimtransactiontype_records()
df = pd.DataFrame(transaction_type_data, columns=columns)

# Ghi dữ liệu vào file CSV
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_transaction_types.csv', index=False)
