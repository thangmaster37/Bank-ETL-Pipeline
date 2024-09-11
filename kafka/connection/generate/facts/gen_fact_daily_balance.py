from faker import Faker
import random
import pandas as pd
import decimal

# Initialize Faker
fake = Faker()

# Generate fake data for FactBalance table
def generate_factbalance_records(num_records):
    data = []
    for _ in range(num_records):
        balance_id = random.randint(1000, 99999)  # Simulated unique interaction ID
        date_id = random.randint(1, 1096)  # Simulate a date_id (e.g., Day of the year)
        account_id = random.randint(1, 150)  # Simulated account ID
        currency_id = random.randint(1, 7)  # Simulated channel ID
        opening_balance = round(decimal.Decimal(random.uniform(1000.00, 1000000.00)), 2)
        closing_balance = round(decimal.Decimal(random.uniform(1000.00, 1000000.00)), 2)
        average_balance = round(decimal.Decimal(random.uniform(1000.00, 1000000.00)), 2)
        
        data.append({
            'balance_id': balance_id,
            'date_id': date_id,
            'account_id': account_id,
            'currency_id': currency_id,
            'opening_balance': opening_balance,
            'closing_balance': closing_balance,
            'average_balance': average_balance
        })
    
    return pd.DataFrame(data)

# Generate 1000 fake balance records
df_balance = generate_factbalance_records(1000)

# Save the data to a CSV file (optional)
df_balance.to_csv('kafka/connection/data/facts/fact_daily_balances.csv', index=False)
