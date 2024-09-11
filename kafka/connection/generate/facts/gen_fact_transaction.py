from faker import Faker
import random
import decimal
import pandas as pd

# Khởi tạo Faker
fake = Faker()

# Các trạng thái giao dịch và kiểu giao dịch có thể có
transaction_statuses = ['Completed', 'Pending', 'Failed', 'Cancelled']

# Tạo dữ liệu giả cho bảng FactTransactions
def generate_facttransaction_records(num_records):
    data = []
    for _ in range(num_records):
        transaction_id = random.randint(1000, 99999)  # Simulated unique interaction ID
        customer_id = random.randint(1, 100)  # Simulated customer ID
        date_id = random.randint(1, 1096)  # Simulate a date_id (e.g., Day of the year)
        channel_id = random.randint(1, 5)  # Simulated channel ID
        account_id = random.randint(1, 150)  # Simulated account ID
        transaction_type_id = random.randint(1, 4)  # Hypothetical transaction type
        location_id = random.randint(1, 100)  # Simulated location ID
        currency_id = random.randint(1, 7)  # Simulated channel ID
        loan_id = random.randint(1, 500)  # Simulated loan ID
        investment_type_id = random.randint(1, 5)  # Hypothetical transaction type
        amount = round(decimal.Decimal(random.uniform(1000.00, 1000000.00)), 2)
        status = random.choice(transaction_statuses)
        
        data.append({
            'transaction_id': transaction_id,
            'customer_id': customer_id,
            'txn_date_id': date_id,
            'channel_id': channel_id,
            'account_id': account_id,
            'txn_type_id': transaction_type_id,
            'location_id': location_id,
            'currency_id': currency_id,
            'loan_id': loan_id,
            'investment_type_id': investment_type_id,
            'txn_amount': amount,
            'txn_status': status
        })
    
    return pd.DataFrame(data)

# Tạo 1000 bản ghi giao dịch giả
df_transactions = generate_facttransaction_records(1000)

# Lưu dữ liệu vào file CSV (tuỳ chọn)
df_transactions.to_csv('kafka/connection/data/facts/fact_transactions.csv', index=False)
