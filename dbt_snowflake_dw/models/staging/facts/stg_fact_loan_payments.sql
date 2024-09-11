{{
    config(
        materialized='incremental',
        alias='stg_fact_loan_payments',
        schema=var('staging_bank_schema'),
        unique_key='payment_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    payment_id,
    date_id,
    loan_id,
    customer_id,
    payment_amount,
    payment_status

FROM 
    {{ source('staging_snowflake', 'fact_loan_payments')}}