{{
    config(
        materialized='incremental',
        alias='stg_fact_customer_interactions',
        schema=var('staging_bank_schema'),
        unique_key='interaction_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    interaction_id,
    date_id,
    channel_id,
    location_id,
    customer_id,
    interaction_type,
    interaction_rating

FROM 
    {{ source('staging_snowflake', 'fact_customer_interactions')}}