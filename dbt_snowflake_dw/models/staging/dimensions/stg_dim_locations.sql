{{
    config(
        materialized='incremental',
        alias='stg_dim_locations',
        schema=var('staging_bank_schema'),
        unique_key='location_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    location_id,
    "address",
    city,
    "state",
    country,
    postal_code

FROM 
    {{ source('staging_snowflake', 'dim_locations')}}