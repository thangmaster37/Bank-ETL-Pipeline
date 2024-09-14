-- models/marts/dimensions/final_dim_locations.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_locations',
        unique_key='locations_id',
        incremental_strategy='merge'
    )
}}

SELECT 
    "location_id",
    "house_number",
    "street_name",
    "apartment_suite"
    "city",
    "state",
    "country",
    "postal_code"

FROM 
    {{ source('staging_snowflake', 'stg_dim_locations') }}

ORDER BY "location_id"
