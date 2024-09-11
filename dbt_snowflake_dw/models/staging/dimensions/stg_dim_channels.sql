{{
    config(
        materialized='incremental',
        alias='stg_dim_channels',
        schema=var('staging_bank_schema'),
        unique_key='channel_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    channel_id,
    channel_name

FROM 
    {{ source('staging_snowflake', 'dim_channels')}}