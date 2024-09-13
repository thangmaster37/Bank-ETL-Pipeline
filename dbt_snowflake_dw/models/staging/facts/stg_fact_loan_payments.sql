-- models/staging/facts/stg_fact_loan_payments.sql

{{
    config(
        materialized='incremental',
        alias='stg_fact_loan_payments',
        schema=var('staging_bank_schema'),
        unique_key='payment_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_fact_loan_payments AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY "payment_id"
            ORDER BY "payment_id" ASC
        ) AS "rank_loan_payment"

    FROM 
        {{ source('staging_snowflake', 'fact_loan_payments') }}
)

SELECT
    "payment"."payment_id",
    "payment"."date_id",
    "payment"."loan_id",
    "payment"."customer_id",
    "payment"."payment_amount",
    LOWER(TRIM("payment"."payment_status")) AS "payment_status"

FROM 
    new_fact_loan_payments AS "payment"

    {{ inner_join_id("staging_snowflake", "dim_dates", "payment", "date", "date_id", "date_id") }}
    {{ inner_join_id("staging_snowflake", "dim_loans", "payment", "loan", "loan_id", "loan_id") }}
    {{ inner_join_id("staging_snowflake", "dim_customers", "payment", "customer", "customer_id", "customer_id") }}

WHERE -- Loại bỏ các record chứa giá trị NULL
      "payment"."payment_id" IS NOT NULL
  AND "payment"."date_id" IS NOT NULL
  AND "payment"."loan_id" IS NOT NULL
  AND "payment"."customer_id" IS NOT NULL
  AND "payment"."payment_amount" IS NOT NULL
  AND "payment"."payment_status" IS NOT NULL
      -- Loại bỏ các trạng thái thanh toán không hợp lệ
  AND "payment"."payment_status" NOT IN ('completed', 'pending', 'failed', 'overdue')
      -- Loại bỏ các tài khoản có số tiền thanh toán không hợp lệ
  AND "payment"."payment_amount" > 0
      -- Loại bỏ các record có rank_loan_payment lớn hơn 1
  AND "payment"."rank_loan_payment" = 1

ORDER BY "payment"."payment_id"
