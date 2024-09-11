from faker import Faker
import random
import pandas as pd
import decimal

# Initialize Faker
fake = Faker()

# Generate fake data for FactInvestment table
def generate_factinvestment_records(num_records):
    data = []
    for _ in range(num_records):
        investment_id = random.randint(1000, 99999)  # Simulated unique interaction ID
        date_id = random.randint(1, 1096)  # Simulate a date_id (e.g., Day of the year)
        investment_type = random.randint(1, 5)  # Simulated investment type ID
        account_id = random.randint(1, 150)  # Simulated account ID
        amount_invested = round(decimal.Decimal(random.uniform(1000.00, 1000000.00)), 2)
        investment_return = round(decimal.Decimal(random.uniform(-1000000.00, 1000000.00)), 2)   
        
        data.append({
            'investment_id': investment_id,
            'date_id': date_id,
            'investment_type': investment_type,
            'account_id': account_id,
            'amount_invested': amount_invested,
            'investment_return': investment_return
        })
    
    return pd.DataFrame(data)

# Generate 1000 fake investment records
df_investment = generate_factinvestment_records(1000)

# Save the data to a CSV file (optional)
df_investment.to_csv('kafka/connection/data/facts/fact_investments.csv', index=False)
