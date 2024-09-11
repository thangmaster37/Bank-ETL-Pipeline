from faker import Faker
import random
import pandas as pd

# Initialize Faker
fake = Faker()

# Possible interaction types and ratings
interaction_types = ['Phone Call', 'Email', 'In-Person', 'Chat', 'Social Media']
interaction_ratings = [1, 2, 3, 4, 5]  # Rating between 1 and 5

# Generate fake data for FactCustomerInteractions table
def generate_factinteraction_records(num_records):
    data = []
    for _ in range(num_records):
        interaction_id = random.randint(1000, 99999)  # Simulated unique interaction ID
        date_id = random.randint(1, 1096)  # Simulate a date_id (e.g., Day of the year)
        customer_id = random.randint(1, 100)  # Simulated customer ID
        channel_id = random.randint(1, 5)  # Simulated channel ID
        location_id = random.randint(1, 100)  # Simulated location ID
        interaction_type = random.choice(interaction_types)
        interaction_rating = random.choice(interaction_ratings)
        
        data.append({
            'interaction_id': interaction_id,
            'date_id': date_id,
            'channel_id': channel_id,
            'location_id': location_id,
            'customer_id': customer_id,
            'interaction_type': interaction_type,
            'interaction_rating': interaction_rating
        })
    
    return pd.DataFrame(data)

# Generate 1000 fake interaction records
df_interaction = generate_factinteraction_records(1000)

# Save the data to a CSV file (optional)
df_interaction.to_csv('kafka/connection/data/facts/fact_customer_interactions.csv', index=False)
