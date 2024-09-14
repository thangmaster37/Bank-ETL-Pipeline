-- models/marts/facts/final_fact_loan_payments.sql

{{
    config(
        materialized='incremental',
        alias='final_fact_loan_payments',
        unique_key='payment_id',
        incremental_strategy='merge'
    )
}}

WITH source_data AS (
    SELECT 
        "payment_id",
        "date_id",
        "loan_id",
        "customer_id",
        "payment_amount",
        "payment_status"

    FROM 
        {{ source('staging_snowflake', 'stg_fact_loan_payments') }}
)

SELECT
    "payment"."payment_id",
    "payment"."date_id",
    "date"."date" AS "date_loan_payment",
    "payment"."loan_id",
    "loan"."loan_type" AS "loan_type",
    "payment"."customer_id",
    "customer"."full_name" AS "name_customer",
    "customer"."house_number" AS "house_number_customer",
    "customer"."street_name" AS "street_name_customer",
    "customer"."city" AS "city_customer",
    "customer"."state" AS "state_customer",
    "payment"."payment_amount",
    "payment"."payment_status"

FROM source_data AS "payment"

{{ inner_join_id("staging_snowflake", "stg_dim_dates", "payment", "date", "date_id", "date_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_loans", "payment", "loan", "loan_id", "loan_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_customers", "payment", "customer", "customer_id", "customer_id") }}

ORDER BY "payment"."payment_id"