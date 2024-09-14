-- models/marts/dimensions/final_dim_channels.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_currencies',
        unique_key='currency_id',
        incremental_strategy='merge'
    )
}}

SELECT
    "currency_id",
    "currency_code",
    "currency_name"

FROM 
    {{ source('staging_snowflake', 'stg_dim_currencies') }}

ORDER BY "currency_id"
