import os
import sys
import logging
import threading
import configparser
from time import sleep
from pathlib import Path
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json
from helper.schema import schema_fact_customer_interaction, \
                          schema_fact_daily_balance, \
                          schema_fact_investment, \
                          schema_fact_loan_payment, \
                          schema_fact_transaction

from helper.convert_field import convert_field_fact_customer_interaction, \
                                 convert_field_fact_daily_balance, \
                                 convert_field_fact_investment, \
                                 convert_field_fact_loan_payment, \
                                 convert_field_fact_transaction


# Đảm bảo sử dụng phiên bản Python hiện tại của bạn
os.environ["PYSPARK_PYTHON"] = sys.executable
os.environ["PYSPARK_DRIVER_PYTHON"] = sys.executable

# Đọc cấu hình từ tệp snowflake_config.cfg
config = configparser.ConfigParser()
config.read_file(open(f"{Path(__file__).parents[0]}/snowflake_config.cfg"))

def create_spark_conn():
    try:
        spark_conn = SparkSession.builder.appName('spark-snowflake-kafka') \
                .master("local[2]") \
                .config("spark.jars", "../jars/snowflake-jdbc-3.16.1.jar, \
                                    ../jars/spark-snowflake_2.12-2.16.0-spark_3.3.jar") \
                .config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1") \
                .getOrCreate()
        
        logging.info('Kết nối Spark được khởi tạo thành công')
        return spark_conn

    except Exception as e:
        logging.error(f'Không thể khởi tạo spark session do ngoại lệ: {e}')
        return None

def conn_to_kafka(spark_conn, topics):
    try:
        spark_df = spark_conn.read \
            .format('kafka') \
            .option('kafka.bootstrap.servers', 'localhost:9092') \
            .option("subscribe", topics) \
            .option('startingOffsets', 'earliest') \
            .load()
        logging.info('Tạo df với dữ liệu từ Kafka Producer thành công')
        return spark_df
    except Exception as e:
        logging.error(f'Df với dữ liệu từ Kafka Producer không thể tạo do ngoại lệ: {e}')
        return None

def apply_schema_data_from_topics(spark_df):
    # Áp dụng schema cho từng topic
    df_fact_customer_interaction = spark_df.filter(col("topic") == "fact-customer-interaction") \
        .withColumn("data", from_json(col("value").cast("string"), schema_fact_customer_interaction)) \
        .select("data.*")
    
    df_fact_customer_interaction_convert = convert_field_fact_customer_interaction(df_fact_customer_interaction)
    
    print(df_fact_customer_interaction_convert.show())
    print(df_fact_customer_interaction_convert.count())


    df_fact_daily_balance = spark_df.filter(col("topic") == "fact-daily-balance") \
        .withColumn("data", from_json(col("value").cast("string"), schema_fact_daily_balance)) \
        .select("data.*")
    
    df_fact_daily_balance_convert = convert_field_fact_daily_balance(df_fact_daily_balance)
    
    print(df_fact_daily_balance_convert.show())
    print(df_fact_daily_balance_convert.count())

    df_fact_investment = spark_df.filter(col("topic") == "fact-investment") \
        .withColumn("data", from_json(col("value").cast("string"), schema_fact_investment)) \
        .select("data.*")
    
    df_fact_investment_convert = convert_field_fact_investment(df_fact_investment)
    
    print(df_fact_investment_convert.show())
    print(df_fact_investment_convert.count())

    df_fact_loan_payment = spark_df.filter(col("topic") == "fact-loan-payment") \
        .withColumn("data", from_json(col("value").cast("string"), schema_fact_loan_payment)) \
        .select("data.*")
    
    df_fact_loan_payment_convert = convert_field_fact_loan_payment(df_fact_loan_payment)
    
    print(df_fact_loan_payment_convert.show())
    print(df_fact_loan_payment_convert.count())

    df_fact_transaction = spark_df.filter(col("topic") == "fact-transaction") \
        .withColumn("data", from_json(col("value").cast("string"), schema_fact_transaction)) \
        .select("data.*")
    
    df_fact_transaction_convert = convert_field_fact_transaction(df_fact_transaction)
    
    print(df_fact_transaction_convert.show())
    print(df_fact_transaction_convert.count())

    return {
        "fact-customer-interaction": df_fact_customer_interaction_convert,
        "fact-daily-balance": df_fact_daily_balance_convert,
        "fact-investment": df_fact_investment_convert,
        "fact-loan-payment": df_fact_loan_payment_convert,
        "fact-transaction": df_fact_transaction_convert
    }

def write_to_snowflake(batch_df, table_name):
    sfOptions = {
        "sfURL" : config.get('SNOWFLAKE', 'URL'),
        "sfUser" : config.get('SNOWFLAKE', 'USER'),
        "sfPassword" : config.get('SNOWFLAKE', 'PASSWORD'),
        "sfDatabase" : config.get('SNOWFLAKE', 'DATABASE'),
        "sfSchema" : config.get('SNOWFLAKE', 'SCHEMA'),
        "sfWarehouse" : config.get('SNOWFLAKE', 'WAREHOUSE'),
        "sfRole" : config.get('SNOWFLAKE', 'ROLE')
    }

    batch_df.write \
            .format("net.snowflake.spark.snowflake") \
            .options(**sfOptions) \
            .option("dbtable", table_name) \
            .mode("append") \
            .save()
 

def process_topic(df, table_name):
    df_limited = df.limit(1000)

    count = df_limited.count()  # Đếm số lượng bản ghi trong DataFrame
    print(f"Số lượng bản ghi trong {table_name}:",count)

    if count == 1000:
        logging.info(f"Đã đạt {count} bản ghi cho {table_name}, tiến hành đẩy lên Snowflake")
        write_to_snowflake(df, table_name)
        

def process_data(df_dict, list_topics, table_names):
    threads = []
    
    for topic, table_name in zip(list_topics, table_names):
        if topic in df_dict:
            df = df_dict[topic]
            # Tạo và bắt đầu một luồng để xử lý từng topic
            thread = threading.Thread(target=process_topic, args=(df, table_name))
            threads.append(thread)
            thread.start()

    # Đợi tất cả các luồng hoàn thành
    for thread in threads:
        thread.join()


if __name__ == "__main__":
    # Danh sách các topic
    list_topics = ['fact-customer-interaction', 'fact-daily-balance', 
                   'fact-investment', 'fact-loan-payment', 'fact-transaction']
    # Danh sách các tên bảng trên snowflake
    table_names = ['fact_customer_interactions', 'fact_daily_balances', 
                   'fact_investments', 'fact_loan_payments', 'fact_transactions']

    # Tạo kết nối Spark
    spark_conn = create_spark_conn()
    sleep(1000)

    if spark_conn is not None:
        # Tạo kết nối đến Kafka
        spark_df = conn_to_kafka(spark_conn, ','.join(list_topics))

        print(spark_df.count())

        if spark_df is not None:
            # Áp dụng schema cho từng topic
            df_dict = apply_schema_data_from_topics(spark_df)

            # Xử lý và đẩy dữ liệu lên Snowflake khi đủ 1000 record
            process_data(df_dict, list_topics, table_names)
