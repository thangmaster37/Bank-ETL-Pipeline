import csv
from time import sleep
import logging

def send_data_topic(file_path, producer, topic):
    try:
        file = open(file_path)
        csvreader = csv.reader(file)
        header = next(csvreader)
        
        for row in csvreader:
            value_row = {}

            for i in range(len(header)):
                field_name = header[i]
                value_row[field_name] = row[i]

            producer.send(topic, value_row)
            sleep(1)

    except Exception as e:
        logging.error(f"Đã xảy ra một lỗi: {e}")


