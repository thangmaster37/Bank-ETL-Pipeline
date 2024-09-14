-- models/staging/dimensions/stg_dim_channels.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_channels',
        unique_key='channel_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_channels AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY LOWER(TRIM("channel_name"))
            ORDER BY "channel_id" ASC
        ) AS "rank_channel"

    FROM 
        {{ source('raw_snowflake', 'dim_channels') }}
)

SELECT
    "channel_id",
    LOWER(TRIM("channel_name")) AS "channel_name"

FROM 
    new_dim_channels

WHERE -- Loại bỏ các record chứa giá trị NULL
      "channel_id" IS NOT NULL
  AND "channel_name" IS NOT NULL
      -- Loại bỏ các kênh giao dịch không có trong ngân hàng
  AND "channel_name" NOT IN ('online', 'mobile app', 'in-store', 'atm', 'telephone')
      -- Loại bỏ các record có rank_channel lớn hơn 1
  AND "rank_channel" = 1

ORDER BY "channel_id"

