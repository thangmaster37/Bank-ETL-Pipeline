{{
    config(
        materialized='incremental',
        alias='stg_fact_daily_balances',
        schema=var('staging_bank_schema'),
        unique_key='balance_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    balance_id,
    date_id,
    account_id,
    currency_id,
    opening_balance,
    closing_balance,
    average_balance

FROM 
    {{ source('staging_snowflake', 'fact_daily_balances')}}