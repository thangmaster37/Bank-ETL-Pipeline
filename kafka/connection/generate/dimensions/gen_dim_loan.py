from faker import Faker
import pandas as pd
import random

# Initialize Faker
fake = Faker()

# Function to generate loan types
def random_loan_type():
    loan_types = ['Personal', 'Home', 'Auto', 'Education', 'Business', 'Credit Card']
    return random.choice(loan_types)

# Generate data for DimLoan
def generate_dimloan_records(num_records):
    data = []

    for loan_id in range(1, num_records + 1):
        loan_type = random_loan_type()
        loan_amount = round(random.uniform(1000, 1000000), 2)  # Random loan amount between 5,000 and 500,000
        interest_rate = round(random.uniform(1.5, 15.0), 2)  # Random interest rate between 1.5% and 15%

        data.append([loan_id, loan_type, loan_amount, interest_rate])

    return data

# Generate data
loan_data = generate_dimloan_records(500)

# Create DataFrame
df = pd.DataFrame(loan_data, columns=['loan_id', 'loan_type', 'loan_amount', 'interest_rate'])

# Save to CSV
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_loans.csv', index=False)
