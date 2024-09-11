{{
    config(
        materialized='incremental',
        alias='stg_dim_accounts',
        schema=var('staging_bank_schema'),
        unique_key='account_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT 
    account_id,
    account_number,
    customer_id,
    account_type,
    account_balance,
    credit_score

FROM 
    {{ source('staging_snowflake', 'dim_accounts') }}
    
