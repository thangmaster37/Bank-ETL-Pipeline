# Bank-ETL-Pipeline

### 🚀 1.DESCRIPTION
In this project, I build a data pipeline with data sent in real time and use DBT to process then store in Snowflake.

### 🧐 2.ARCHITECTURE

![UI](images/bank-architecture.png)

### ⭐️ 3.DATA WAREHOUSE

![UI](design/design_data_warehouse.png)

### 🔥 4.SET UP AND RUN

Due to hardware limitations in my computer, in this project I built kafka and airflow at the same time. First run move to the "airflow" directory and run: 

<p align="center"><strong>docker-compose up -d --build</strong></p>

After running successfully, kafka and Airflow have been built on docker. Next, we have to build the dependencies on Snowflake as follows:

- Move to the "scripts" folder and run: <strong>python run_scripts.py</strong>

Now let's start running Kafka and Airflow to send data to Snowflake and transform the data with Dbt:

- Run Apache Kafka:
  - Move to the "airflow" directory and run: <strong>docker-compose up</strong>
  - Move to the "spark streaming/connection" directory and run: <strong>python consumer_bank.py</strong>
  - Move to the "kafka/connection" directory and run: <strong>python producer_bank.py</strong>

- Run Apache Airflow:
  - Move to the "airflow" directory and run: <strong>docker-compose up</strong>

### ✅ 5.FINAL RESULT
- Data pipeline for my project

![UI](images/airflow-dag.png)

- Lineage graph in Dbt

![UI](images/dbt-dag.png)

### 🚨 6.CONCLUSION

Basically, in this project I want to focus mainly on using Dbt for data transformation because nowadays Dbt is gradually becoming a powerful tool in data processing with SQL statements.
