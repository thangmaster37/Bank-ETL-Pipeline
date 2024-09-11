{{
    config(
        materialized='incremental',
        alias='stg_dim_customers',
        schema=var('staging_bank_schema'),
        unique_key='customer_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    "address",
    city,
    "state",
    postal_code,
    phone_number

FROM 
    {{ source('staging_snowflake', 'dim_customers')}}