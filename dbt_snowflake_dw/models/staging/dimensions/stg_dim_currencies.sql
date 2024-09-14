-- models/staging/dimensions/stg_dim_currencies.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_currencies',
        unique_key='currency_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_currencies AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY LOWER(TRIM("currency_code"))
            ORDER BY "currency_id" ASC
        ) AS "rank_currency"

    FROM 
        {{ source('raw_snowflake', 'dim_currencies') }}
)

SELECT
    "currency_id",
    LOWER(TRIM("currency_code")) AS "currency_code",
    LOWER(TRIM("currency_name")) AS "currency_name"

FROM 
    new_dim_currencies

WHERE -- Loại bỏ các record chứa giá trị NULL
      "currency_id" IS NOT NULL
  AND "currency_code" IS NOT NULL
  AND "currency_name" IS NOT NULL
      -- Loại bỏ các kênh giao dịch không có trong ngân hàng
  AND "currency_code" NOT IN ('usd', 'eur', 'jpy', 'vnd', 'gbp', 'cny', 'sgd')
      -- Loại bỏ các record có rank_currency lớn hơn 1
  AND "rank_currency" = 1

ORDER BY "currency_id"