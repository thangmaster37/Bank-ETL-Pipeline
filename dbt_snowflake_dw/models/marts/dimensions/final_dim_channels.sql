-- models/marts/dimensions/final_dim_channels.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_channels',
        unique_key='channel_id',
        incremental_strategy='merge'
    )
}}

SELECT
    "channel_id",
    "channel_name"

FROM 
    {{ source('staging_snowflake', 'stg_dim_channels') }}

ORDER BY "channel_id"
