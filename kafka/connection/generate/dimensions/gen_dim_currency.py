from faker import Faker
import pandas as pd
import random
import decimal

# Khởi tạo đối tượng Faker
fake = Faker(['en_US'])


# Hàm để tạo dữ liệu giả cho bảng DimCurrency
def generate_dimcurrency_records():
    records = [[1,"USD", "US Dollar"], 
               [2, "EUR", "Euro"], 
               [3, "JPY", "Japanese Yen"], 
               [4, "VND", "VietNam Dong"], 
               [5, "GBP", "British Pound Sterling"], 
               [6, "CNY", "Chinese Yuan Renminbi"], 
               [7, "SGD", "Singapore Dollar"]]
    return records

# Tạo DataFrame
columns = [
    'currency_id', 'currency_code', 'currency_name'
]
currency_data = generate_dimcurrency_records()
df = pd.DataFrame(currency_data, columns=columns)

# Ghi dữ liệu vào file CSV
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_currencies.csv', index=False)
