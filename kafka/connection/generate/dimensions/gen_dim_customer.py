from faker import Faker
import pandas as pd
import random

# Khởi tạo đối tượng Faker
fake = Faker(['en_US'])

# Hàm để tạo ngẫu nhiên postal code
def generate_postal_code():
    return str(random.randint(10000, 99999))

# Hàm để tạo dữ liệu giả cho DimCustomer
def generate_dimcustomer_records(n=100):
    customers = []
    for customer_id in range(1, n + 1):
        first_name = fake.first_name()
        last_name = fake.last_name()
        email = f"{first_name.lower()}{last_name.lower()}@{fake.free_email_domain()}"
        address = fake.street_address()
        city = fake.city()
        state = fake.state()
        postal_code = generate_postal_code()
        phone_number = fake.phone_number()
        customers.append([
            customer_id, first_name, last_name, email, address, city, state, postal_code, phone_number
        ])
    return customers

# Create a DataFrame
columns = [
    'customer_id', 'first_name', 'last_name', 'email', 'address', 
    'city', 'state', 'postal_code', 'phone_number'
]
customer_data = generate_dimcustomer_records(100)
df = pd.DataFrame(customer_data, columns=columns)

# Save to a CSV file if needed
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_customers.csv', index=False)