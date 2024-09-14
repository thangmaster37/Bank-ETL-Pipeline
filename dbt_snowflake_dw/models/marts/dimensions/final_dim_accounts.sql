-- models/marts/dimensions/final_dim_accounts.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_accounts',
        unique_key='account_id',
        incremental_strategy='merge'
    )
}}

SELECT 
    "account_id", 
    "account_number",
    "customer_id",
    "account_type",
    "account_balance",
    "credit_score"

FROM 
    {{ source('staging_snowflake', 'stg_dim_accounts') }}

ORDER BY "account_id"
