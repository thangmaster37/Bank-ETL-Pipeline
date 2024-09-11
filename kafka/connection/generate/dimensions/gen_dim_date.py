from faker import Faker
import pandas as pd
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta

# Khởi tạo Faker
fake = Faker()

# Hàm để tạo một chuỗi thời gian
def generate_dimdate_records(start_date, end_date):
    current_date = start_date
    data = []

    while current_date <= end_date:
        date_id = int((current_date - datetime(2022, 1, 1)).days + 1)  # Unique ID for each date
        day = current_date.day
        month = current_date.month
        year = current_date.year
        quarter = (current_date.month - 1) // 3 + 1
        weekday = current_date.isoweekday()

        data.append([date_id, current_date, day, month, year, quarter, weekday])
        current_date += relativedelta(days=1)

    return data

# Generate data for the years 2022, 2023, and 2024
start_date = datetime(2022, 1, 1)
end_date = datetime(2024, 12, 31)
date_data = generate_dimdate_records(start_date, end_date)

# Create DataFrame
df = pd.DataFrame(date_data, columns=['date_id', 'date', 'day', 'month', 'year', 'quarter', 'weekday'])

# Save to CSV
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_dates.csv', index=False)
