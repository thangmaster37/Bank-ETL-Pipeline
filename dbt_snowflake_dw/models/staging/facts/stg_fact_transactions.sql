-- models/staging/facts/stg_fact_transactions.sql

{{
    config(
        materialized='incremental',
        alias='stg_fact_transactions',
        schema=var('staging_bank_schema'),
        unique_key='transaction_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_fact_transactions AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY "transaction_id"
            ORDER BY "transaction_id" ASC
        ) AS "rank_transaction"

    FROM 
        {{ source('staging_snowflake', 'fact_transactions') }}
)

SELECT
    "transaction"."transaction_id",
    "transaction"."customer_id",
    "transaction"."txn_date_id",
    "transaction"."channel_id",
    "transaction"."account_id",
    "transaction"."txn_type_id",
    "transaction"."location_id",
    "transaction"."currency_id",
    "transaction"."loan_id",
    "transaction"."investment_type_id",
    "transaction"."txn_amount",
    LOWER(TRIM("transaction"."txn_status")) AS "txn_status"

FROM 
    new_fact_transactions AS "transaction"

    {{ inner_join_id("staging_snowflake", "dim_customers", "transaction", "customer", "customer_id", "customer_id") }}
    {{ inner_join_id("staging_snowflake", "dim_dates", "transaction", "date", "txn_date_id", "date_id") }}
    {{ inner_join_id("staging_snowflake", "dim_channels", "transaction", "channel", "channel_id", "channel_id") }}
    {{ inner_join_id("staging_snowflake", "dim_accounts", "transaction", "account", "account_id", "account_id") }}
    {{ inner_join_id("staging_snowflake", "dim_transaction_types", "transaction", "transaction_type", "txn_type_id", "transaction_type_id") }}
    {{ inner_join_id("staging_snowflake", "dim_locations", "transaction", "location", "location_id", "location_id") }}
    {{ inner_join_id("staging_snowflake", "dim_currencies", "transaction", "currency", "currency_id", "currency_id") }}
    {{ inner_join_id("staging_snowflake", "dim_loans", "transaction", "loan", "loan_id", "loan_id") }}
    {{ inner_join_id("staging_snowflake", "dim_investment_types", "transaction", "investment_type", "investment_type_id", "investment_type_id") }}

WHERE -- Loại bỏ các record chứa giá trị NULL
      "transaction"."transaction_id" IS NOT NULL
  AND "transaction"."customer_id" IS NOT NULL
  AND "transaction"."txn_date_id" IS NOT NULL
  AND "transaction"."channel_id" IS NOT NULL
  AND "transaction"."account_id" IS NOT NULL
  AND "transaction"."txn_type_id" IS NOT NULL
  AND "transaction"."location_id" IS NOT NULL
  AND "transaction"."currency_id" IS NOT NULL
  AND "transaction"."loan_id" IS NOT NULL
  AND "transaction"."investment_type_id" IS NOT NULL
  AND "transaction"."txn_amount" IS NOT NULL
  AND "transaction"."txn_status" IS NOT NULL
      -- Loại bỏ các trạng thái giao dịch không hợp lệ
  AND "transaction"."txn_status" NOT IN ('completed', 'pending', 'failed', 'cancelled')
      -- Loại bỏ các tài khoản có số tiền giao dịch không hợp lệ
  AND "transaction"."txn_amount" > 0
      -- Loại bỏ các record có rank_transaction lớn hơn 1
  AND "transaction"."rank_transaction" = 1

ORDER BY "transaction"."transaction_id"
