-- models/staging/facts/stg_fact_daily_balances.sql

{{
    config(
        materialized='incremental',
        alias='stg_fact_daily_balances',
        unique_key='balance_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_fact_daily_balances AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY "balance_id"
            ORDER BY "balance_id" ASC
        ) AS "rank_daily_balance"

    FROM 
        {{ source('raw_snowflake', 'fact_daily_balances') }}
)

SELECT
    "balance"."balance_id",
    "balance"."date_id",
    "balance"."account_id",
    "balance"."currency_id",
    "balance"."opening_balance",
    "balance"."closing_balance",
    "balance"."average_balance"

FROM 
    new_fact_daily_balances AS "balance"

    {{ inner_join_id("raw_snowflake", "dim_dates", "balance", "date", "date_id", "date_id") }}
    {{ inner_join_id("raw_snowflake", "dim_accounts", "balance", "account", "account_id", "account_id") }}
    {{ inner_join_id("raw_snowflake", "dim_currencies", "balance", "currency", "currency_id", "currency_id") }}

WHERE -- Loại bỏ các record chứa giá trị NULL
      "balance"."balance_id" IS NOT NULL
  AND "balance"."date_id" IS NOT NULL
  AND "balance"."account_id" IS NOT NULL
  AND "balance"."currency_id" IS NOT NULL
  AND "balance"."opening_balance" IS NOT NULL
  AND "balance"."closing_balance" IS NOT NULL
  AND "balance"."average_balance" IS NOT NULL
      -- Loại bỏ các tài khoản có số dư không hợp lệ
  AND "balance"."opening_balance" > 0
  AND "balance"."closing_balance" > 0
  AND "balance"."average_balance" > 0
      -- Loại bỏ các record có rank_daily_balance lớn hơn 1
  AND "balance"."rank_daily_balance" = 1

ORDER BY "balance"."balance_id"