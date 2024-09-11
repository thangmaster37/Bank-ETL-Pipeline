from faker import Faker
import random
import pandas as pd
import decimal

# Initialize Faker
fake = Faker()

# Possible payment statuses
payment_statuses = ['Completed', 'Pending', 'Failed', 'Overdue']

# Generate fake data for FactLoanPayment table
def generate_factloanpayment_records(num_records):
    data = []
    for _ in range(num_records):
        payment_id = random.randint(1000, 99999)  # Simulated unique interaction ID
        date_id = random.randint(1, 1096)  # Simulate a date_id (e.g., Day of the year)
        loan_id = random.randint(1, 500)  # Simulated loan ID
        customer_id = random.randint(1, 100)  # Simulated customer ID
        payment_amount = round(decimal.Decimal(random.uniform(1000.00, 1000000.00)), 2)
        payment_status = random.choice(payment_statuses)       
        
        data.append({
            'payment_id': payment_id,
            'date_id': date_id,
            'loan_id': loan_id,
            'customer_id': customer_id,
            'payment_amount': payment_amount,
            'payment_status': payment_status
        })
    
    return pd.DataFrame(data)

# Generate 1000 fake payment records
df_payment = generate_factloanpayment_records(1000)

# Save the data to a CSV file (optional)
df_payment.to_csv('kafka/connection/data/facts/fact_loan_payments.csv', index=False)
