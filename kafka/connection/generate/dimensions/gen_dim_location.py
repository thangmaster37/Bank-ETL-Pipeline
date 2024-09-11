from faker import Faker
import random
import pandas as pd

# Initialize Faker
fake = Faker()

# Function to generate a random postal code
def generate_postal_code():
    return str(random.randint(10000, 99999))

# Generate a function to create fake DimLocation data
def generate_dimlocation_records(num_records):
    data = []
    for location_id in range(1, num_records+1):
        address = fake.street_address()
        city = fake.city()
        state = fake.state()
        country = fake.country()
        postal_code = generate_postal_code()

        data.append([
            location_id, address, city, state, country, postal_code
        ])
    
    return data

# Generate 100 fake location records
location_data = generate_dimlocation_records(100)

# Create DataFrame
df = pd.DataFrame(location_data, columns=['location_id', 'address', 'city', 'state', 'country', 'postal_code'])

# Save the data to a CSV file (optional)
df.to_csv('dbt_snowflake_dw\seeds\dimensions\dim_locations.csv', index=False)
