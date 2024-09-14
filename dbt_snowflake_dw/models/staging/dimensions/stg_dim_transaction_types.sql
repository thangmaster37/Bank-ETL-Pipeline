-- models/staging/dimensions/stg_dim_transaction_types.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_transaction_types',
        unique_key='transaction_type_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_transaction_types AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY LOWER(TRIM("transaction_type_name"))
            ORDER BY "transaction_type_id" ASC
        ) AS "rank_transaction_type"

    FROM 
        {{ source('raw_snowflake', 'dim_transaction_types') }}
)

SELECT
    "transaction_type_id",
    LOWER(TRIM("transaction_type_name")) AS "transaction_type_name"

FROM 
    new_dim_transaction_types

WHERE -- Loại bỏ các record chứa giá trị NULL
      "transaction_type_id" IS NOT NULL
  AND "transaction_type_name" IS NOT NULL
      -- Loại bỏ các kiểu giao dịch không có trong ngân hàng
  AND "transaction_type_name" NOT IN ('deposit', 'withdrawal', 'transfer', 'payment')
      -- Loại bỏ các record có rank_transaction_type lớn hơn 1
  AND "rank_transaction_type" = 1

ORDER BY "transaction_type_id"