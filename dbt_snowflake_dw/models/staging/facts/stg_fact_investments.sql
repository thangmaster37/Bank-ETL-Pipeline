{{
    config(
        materialized='incremental',
        alias='stg_fact_investments',
        schema=var('staging_bank_schema'),
        unique_key='investment_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    investment_id,
    date_id,
    investment_type,
    account_id,
    amount_invested,
    investment_return

FROM 
    {{ source('staging_snowflake', 'fact_investments')}}