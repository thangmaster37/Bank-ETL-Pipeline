-- models/marts/facts/final_fact_customer_interactions.sql

{{
    config(
        materialized='incremental',
        alias='final_fact_customer_interactions',
        unique_key='interaction_id',
        incremental_strategy='merge'
    )
}}

WITH source_data AS (
    SELECT 
        "interaction_id",
        "date_id",
        "channel_id",
        "location_id",
        "customer_id",
        "interaction_type",
        "interaction_rating"

    FROM 
        {{ source('staging_snowflake', 'stg_fact_customer_interactions') }}
)

SELECT
    "interaction"."interaction_id",
    "interaction"."date_id",
    "date"."date" AS "date_interaction",
    "interaction"."customer_id",
    "customer"."full_name" AS "name_customer",
    "customer"."house_number" AS "house_number_customer",
    "customer"."street_name" AS "street_name_customer",
    "customer"."city" AS "city_customer",
    "customer"."state" AS "state_customer",
    "interaction"."channel_id",
    "channel"."channel_name" AS "channel_interaction",
    "interaction"."location_id",
    "location"."house_number" AS "house_number_interaction",
    "location"."street_name" AS "street_name_interaction",
    "location"."city" AS "city_interaction",
    "location"."state" AS "state_interaction",
    "location"."country" AS "country_interaction",
    "interaction"."interaction_type",
    "interaction"."interaction_rating"

FROM source_data as "interaction"

{{ inner_join_id("staging_snowflake", "stg_dim_dates", "interaction", "date", "date_id", "date_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_channels", "interaction", "channel", "channel_id", "channel_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_locations", "interaction", "location", "location_id", "location_id") }}
{{ inner_join_id("staging_snowflake", "stg_dim_customers", "interaction", "customer", "customer_id", "customer_id") }}

ORDER BY "interaction"."interaction_id"