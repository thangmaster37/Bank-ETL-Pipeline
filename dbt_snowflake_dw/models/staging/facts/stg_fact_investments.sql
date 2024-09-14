-- models/staging/facts/stg_fact_investments.sql

{{
    config(
        materialized='incremental',
        alias='stg_fact_investments',
        unique_key='investment_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_fact_investments AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY "investment_id"
            ORDER BY "investment_id" ASC
        ) AS "rank_investment"

    FROM 
        {{ source('raw_snowflake', 'fact_investments') }}
)

SELECT
    "investment"."investment_id",
    "investment"."date_id",
    "investment"."investment_type",
    "investment"."account_id",
    "investment"."amount_invested",
    "investment"."investment_return"

FROM 
    new_fact_investments AS "investment"

    {{ inner_join_id("raw_snowflake", "dim_dates", "investment", "date", "date_id", "date_id") }}
    {{ inner_join_id("raw_snowflake", "dim_investment_types", "investment", "investment_type", "investment_type", "investment_type_id") }}
    {{ inner_join_id("raw_snowflake", "dim_accounts", "investment", "account", "account_id", "account_id") }}

WHERE -- Loại bỏ các record chứa giá trị NULL
      "investment"."investment_id" IS NOT NULL
  AND "investment"."date_id" IS NOT NULL
  AND "investment"."investment_type" IS NOT NULL
  AND "investment"."account_id" IS NOT NULL
  AND "investment"."amount_invested" IS NOT NULL
  AND "investment"."investment_return" IS NOT NULL
      -- Loại bỏ các tài khoản có số tiền đầu tư không hợp lệ
  AND "investment"."amount_invested" > 0
      -- Loại bỏ các record có rank_investment lớn hơn 1
  AND "investment"."rank_investment" = 1

ORDER BY "investment"."investment_id"