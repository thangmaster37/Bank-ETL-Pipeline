-- models/staging/dimensions/stg_dim_accounts.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_accounts',
        unique_key='account_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_accounts AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY 
                TRIM("account_number"), 
                "customer_id", 
                LOWER(TRIM("account_type")) 
            ORDER BY "account_id" ASC
        ) AS "rank_account"

    FROM 
        {{ source('raw_snowflake', 'dim_accounts') }}
)

SELECT 
    "account"."account_id", 
    TRIM("account"."account_number") AS "account_number",
    "account"."customer_id",
    LOWER(TRIM("account"."account_type")) AS "account_type",
    "account"."account_balance",
    "account"."credit_score"

FROM 
    new_dim_accounts AS "account"

INNER JOIN 
    {{ source('raw_snowflake', 'dim_customers') }} AS "customer" 
    ON "account"."customer_id" = "customer"."customer_id"

WHERE -- Loại bỏ các record chứa giá trị NULL
      "account_id" IS NOT NULL
  AND "account_number" IS NOT NULL
  AND "account"."customer_id" IS NOT NULL
  AND "account_type" IS NOT NULL
  AND "account_balance" IS NOT NULL
  AND "credit_score" IS NOT NULL
      -- Loại bỏ các kiểu tài khoản không có trong ngân hàng
  AND "account_type" NOT IN ('checking', 'savings', 'loan', 'investment')
      -- Loại bỏ các tài khoản có số dư bé hơn 0
  AND "account_balance" >= 0
      -- Loại bỏ các record có rank_account lớn hơn 1
  AND "rank_account" = 1

ORDER BY "account_id"

    


    
