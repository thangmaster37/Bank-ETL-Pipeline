# Bank-ETL-Pipeline

### 🚀 1.DESCRIPTION
In this project, I build a data pipeline with data sent in real time and use DBT to process then store in Snowflake.

### 🧐 2.ARCHITECTURE

![UI](images/bank-architecture.png)

Run: dbt compile --models staging.dimensions.stg_dim_accounts / dbt compile --models staging
Run: dbt run --models staging / dbt run --select models/staging/dimensions/stg_dim_accounts.sql
