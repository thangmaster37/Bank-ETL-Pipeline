from faker import Faker
import pandas as pd
import random
import decimal

# Khởi tạo đối tượng Faker
fake = Faker(['en_US'])


# Hàm để tạo dữ liệu giả cho bảng DimChannel
def generate_dimchannel_records():
    records = [[1,"Online"], [2, "Mobile App"], [3, "In-Store"], [4, "ATM"], [5, "Telephone"]]
    return records

# Tạo DataFrame
columns = [
    'channel_id', 'channel_name'
]
channel_data = generate_dimchannel_records()
df = pd.DataFrame(channel_data, columns=columns)

# Ghi dữ liệu vào file CSV
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_channels.csv', index=False)
