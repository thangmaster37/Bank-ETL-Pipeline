-- models/marts/facts/final_fact_transactions.sql

{{
    config(
        materialized='incremental',
        alias='final_fact_transactions',
        unique_key='transaction_id',
        incremental_strategy='merge'
    )
}}

WITH source_data AS (
    SELECT 
        "transaction_id",
        "customer_id",
        "txn_date_id",
        "channel_id",
        "account_id",
        "txn_type_id",
        "location_id",
        "currency_id",
        "loan_id",
        "investment_type_id",
        "txn_amount",
        "txn_status"

    FROM 
        {{ source('staging_snowflake', 'stg_fact_transactions') }}
)

SELECT 
    "transaction"."transaction_id",
    "transaction"."customer_id",
    "customer"."full_name" AS "name_customer",
    "customer"."house_number" AS "house_number_customer",
    "customer"."street_name" AS "street_name_customer",
    "customer"."city" AS "city_customer",
    "customer"."state" AS "state_customer",
    "transaction"."txn_date_id",
    "date"."date" AS "date_transaction",
    "transaction"."channel_id",
    "channel"."channel_name" AS "channel_transaction",
    "transaction"."account_id",
    "account"."account_number" AS "account_transaction",
    "account"."account_type" AS "account_type_transaction",
    "transaction"."txn_type_id",
    "transaction_type"."transaction_type_name" AS "transaction_type_name",
    "transaction"."location_id",
    "location"."house_number" AS "house_number_transaction",
    "location"."street_name" AS "street_name_transaction",
    "location"."city" AS "city_transaction",
    "location"."state" AS "state_transaction",
    "location"."country" AS "country_transaction",
    "transaction"."currency_id",
    "currency"."currency_code" AS "currency_code_transaction",
    "transaction"."loan_id",
    "loan"."loan_type" AS "loan_type",
    "transaction"."investment_type_id",
    "investment_type"."investment_type_name" AS "investment_type_name",
    "transaction"."txn_amount",
    "transaction"."txn_status"

FROM source_data AS "transaction"

{{ inner_join_id("staging_snowflake", "stg_dim_customers", "transaction", "customer", "customer_id", "customer_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_dates", "transaction", "date", "txn_date_id", "date_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_channels", "transaction", "channel", "channel_id", "channel_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_accounts", "transaction", "account", "account_id", "account_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_transaction_types", "transaction", "transaction_type", "txn_type_id", "transaction_type_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_locations", "transaction", "location", "location_id", "location_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_currencies", "transaction", "currency", "currency_id", "currency_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_loans", "transaction", "loan", "loan_id", "loan_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_investment_types", "transaction", "investment_type", "investment_type_id", "investment_type_id") }}

ORDER BY "transaction"."transaction_id"