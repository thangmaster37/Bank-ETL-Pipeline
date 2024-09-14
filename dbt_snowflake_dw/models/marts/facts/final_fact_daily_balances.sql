-- models/marts/facts/final_fact_daily_balances.sql

{{
    config(
        materialized='incremental',
        alias='final_fact_daily_balances',
        unique_key='balance_id',
        incremental_strategy='merge'
    )
}}

WITH source_data AS (
    SELECT 
        "balance_id",
        "date_id",
        "account_id",
        "currency_id",
        "opening_balance",
        "closing_balance",
        "average_balance"

    FROM 
        {{ source('staging_snowflake', 'stg_fact_daily_balances') }}
)

SELECT
    "balance"."balance_id",
    "balance"."date_id",
    "date"."date" AS "date_balance",
    "balance"."account_id",
    "account"."account_number" AS "account_balance",
    "account"."account_type" AS "account_type_balance",
    "balance"."currency_id",
    "currency"."currency_code" AS "currency_code_balance",
    "balance"."opening_balance",
    "balance"."closing_balance",
    "balance"."average_balance"

FROM source_data AS "balance"

{{ inner_join_id("staging_snowflake", "stg_dim_dates", "balance", "date", "date_id", "date_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_accounts", "balance", "account", "account_id", "account_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_currencies", "balance", "currency", "currency_id", "currency_id") }}

ORDER BY "balance"."balance_id"