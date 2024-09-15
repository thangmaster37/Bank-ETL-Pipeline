import logging
import threading
from kafka import KafkaProducer
from kafka.admin import KafkaAdminClient, NewTopic
from helper.other import json_serializer
from helper.send_data import send_data_topic
from kafka.errors import TopicAlreadyExistsError

# Cấu hình cơ bản cho logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Hàm tạo các topic để chuyền các dữ liệu
def create_topic(): 

    # Khởi tạo Admin Kafka mục đíhc cho việc khởi tạo các topic
    admin_client = KafkaAdminClient(
        bootstrap_servers="localhost:9092", 
        client_id='admin-permission'
    )

    # admin_client.delete_topics(['fact-customer-interaction', 
    #                             'fact-daily-balance', 
    #                             'fact-investment',
    #                             'fact-loan-payment',
    #                             'fact-transaction'])

    # Tạo các topic
    topic_list = [NewTopic(name="fact-customer-interaction", num_partitions=2, replication_factor=1),
                    NewTopic(name="fact-daily-balance", num_partitions=2, replication_factor=1),
                    NewTopic(name="fact-investment", num_partitions=2, replication_factor=1),
                    NewTopic(name="fact-loan-payment", num_partitions=2, replication_factor=1),
                    NewTopic(name="fact-transaction", num_partitions=2, replication_factor=1)]

    # Lấy danh sách các topic hiện có
    existing_topics = set(admin_client.list_topics())

    # Xác định các topic cần tạo
    topics_to_create = [topic for topic in topic_list if topic.name not in existing_topics]

    if topics_to_create:
        try:
            # Tạo các topic chưa tồn tại
            admin_client.create_topics(new_topics=topics_to_create, validate_only=False)
            logging.info(f"Created topics successfully")
        
        except TopicAlreadyExistsError as e:
            logging.error("Some topics already exist:", e)
    else:
        logging.info("All topics already exist.")

    return admin_client
    

# Hàm tạo kafka producer và truyền dữ liệu đến mỗi topic
def stream_data():
    try:
        # Khởi tạo Kafka Producer
        producer = KafkaProducer(bootstrap_servers = ['localhost:9092'],
                                value_serializer = json_serializer,
                                api_version = (0, 10, 1))

        # Tạo các luồng để gửi dữ liệu đến các topic cùng lúc
        threads = []

        threads.append(threading.Thread(target=send_data_topic, args=('./data/facts/fact_customer_interactions.csv', producer, 'fact-customer-interaction')))
        threads.append(threading.Thread(target=send_data_topic, args=('./data/facts/fact_daily_balances.csv', producer, 'fact-daily-balance')))
        threads.append(threading.Thread(target=send_data_topic, args=('./data/facts/fact_investments.csv', producer, 'fact-investment')))
        threads.append(threading.Thread(target=send_data_topic, args=('./data/facts/fact_loan_payments.csv', producer, 'fact-loan-payment')))
        threads.append(threading.Thread(target=send_data_topic, args=('./data/facts/fact_transactions.csv', producer, 'fact-transaction')))

        # Khởi động tất cả các luồng
        for thread in threads:
            thread.start()

        # Đợi tất cả các luồng hoàn thành
        for thread in threads:
            thread.join()

    except Exception as e:
        logging.error(f'Đã xảy ra một lỗi: {e}')

if __name__ == "__main__":
    admin_client = create_topic()
    # Lấy danh sách các topics hiện có
    existing_topics = admin_client.list_topics()
    # Kiểm tra xem các topic đã được tạo hay chưa
    # Nếu được tạo thì bắt đầu gửi dữ liệu và ngược lại thì không gửi dữ liệu
    if len(existing_topics) != 5:
        stream_data()
    else:
        logging.info('Các topic chưa được tạo đầy đủ để bắt đầu gửi dữ liệu')



