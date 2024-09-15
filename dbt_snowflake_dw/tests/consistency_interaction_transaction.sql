
-- Kiểm tra sự nhất quán giữa 2 bảng: 
-- + fact_customer_interactions
-- + fact_transactions 


WITH customer_interaction AS (
    SELECT
        "interaction_id",
        "date_id",
        "customer_id",
        "channel_id",
        "location_id"

    FROM
        {{ source('final_snowflake', 'final_fact_customer_interactions')}}
),

transaction AS (
    SELECT
        "transaction_id",
        "txn_date_id",
        "customer_id",
        "channel_id",
        "location_id"

    FROM 
        {{ source('final_snowflake', 'final_fact_transactions')}}
)

SELECT 
    "fci"."interaction_id",
    "fci"."date_id",
    "fci"."customer_id",
    "fci"."channel_id",
    "fci"."location_id"

FROM 
    customer_interaction "fci"
    
LEFT JOIN 
    transaction "ft" ON "fci"."date_id" = "ft"."txn_date_id"
                    AND "fci"."customer_id" = "ft"."customer_id"
                    AND "fci"."channel_id" = "ft"."channel_id"
                    AND "fci"."location_id" = "ft"."location_id"
                
WHERE "ft"."transaction_id" IS NULL;

-- Khi chạy code này nếu có bản ghi xuất hiện chứng tỏ dữ liệu đang không nhất quán (dữ liệu bị sai sót)

