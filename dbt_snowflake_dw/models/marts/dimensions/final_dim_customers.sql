-- models/marts/dimensions/final_dim_customers.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_customers',
        unique_key='customer_id',
        incremental_strategy='merge'
    )
}}

SELECT
    "customer_id",
    "first_name",
    "last_name",
    "full_name",
    "email",
    "house_number",
    "street_name",
    "apartment_suite",
    "city",
    "state",
    "postal_code",
    "phone_number"

FROM 
    {{ source('staging_snowflake', 'stg_dim_customers') }}

ORDER BY "customer_id"
