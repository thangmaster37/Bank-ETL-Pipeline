{{
    config(
        materialized='incremental',
        alias='stg_fact_transactions',
        schema=var('staging_bank_schema'),
        unique_key='transaction_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    transaction_id,
    customer_id,
    txn_date_id,
    channel_id,
    account_id,
    txn_type_id,
    location_id,
    currency_id,
    loan_id,
    investment_type_id,
    txn_amount,
    txn_status

FROM 
    {{ source('staging_snowflake', 'fact_transactions')}}