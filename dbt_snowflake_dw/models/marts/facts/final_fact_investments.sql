-- models/marts/facts/final_fact_investments.sql

{{
    config(
        materialized='incremental',
        alias='final_fact_investments',
        unique_key='investment_id',
        incremental_strategy='merge'
    )
}}

WITH source_data AS (
    SELECT 
        "investment_id",
        "date_id",
        "investment_type",
        "account_id",
        "amount_invested",
        "investment_return"

    FROM 
        {{ source('staging_snowflake', 'stg_fact_investments') }}
)

SELECT 
    "investment"."investment_id",
    "investment"."date_id",
    "date"."date" AS "date_investment",
    "investment"."investment_type" AS "investment_type_id",
    "investment_type"."investment_type_name" AS "investment_type_name",
    "investment"."account_id",
    "account"."account_number" AS "account_investment",
    "account"."account_type" AS "account_type_investment",
    "investment"."amount_invested",
    "investment"."investment_return"

FROM source_data AS "investment"

{{ inner_join_id("staging_snowflake", "stg_dim_dates", "investment", "date", "date_id", "date_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_investment_types", "investment", "investment_type", "investment_type", "investment_type_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_accounts", "investment", "account", "account_id", "account_id") }}

ORDER BY "investment"."investment_id"