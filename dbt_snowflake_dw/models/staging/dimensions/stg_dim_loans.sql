-- models/staging/dimensions/stg_dim_loans.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_loans',
        unique_key='loan_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_loans AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY "loan_id"
            ORDER BY "loan_id" ASC
        ) AS "rank_loan"

    FROM 
        {{ source('raw_snowflake', 'dim_loans') }}
)

SELECT
    "loan_id",
    LOWER(TRIM("loan_type")) AS "loan_type",
    "loan_amount",
    "interest_rate"

FROM 
    new_dim_loans

WHERE -- Loại bỏ các record chứa giá trị NULL
      "loan_id" IS NOT NULL
  AND "loan_type" IS NOT NULL
  AND "loan_amount" IS NOT NULL
  AND "interest_rate" IS NOT NULL
      -- Loại bỏ các kiểu vay không có trong ngân hàng
  AND "loan_type" NOT IN ('business', 'education', 'home', 'personal', 'credit card', 'auto')
      -- Loại bỏ các khoản vay có số tiền vay không hợp lệ
  AND "loan_amount" > 0
      -- Loại bỏ các record có rank_loan lớn hơn 1
  AND "rank_loan" = 1

ORDER BY "loan_id"