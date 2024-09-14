-- models/marts/dimensions/final_dim_loans.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_loans',
        unique_key='loan_id',
        incremental_strategy='merge'
    )
}}

SELECT 
    "loan_id",
    "loan_type",
    "loan_amount",
    "interest_rate"

FROM 
    {{ source('staging_snowflake', 'stg_dim_loans') }}

ORDER BY "loan_id"
