
-- Phân tích đối tượng khách hàng dựa trên hành vi giao dịch của họ
-- Mục tiêu của nghiên cứu:
-- + Giúp các doanh nghiệp tạo ra các chiến lược marketing phù hợp với từng nhóm khách hàng cụ thể, từ đó tối ưu hóa chiến dịch quảng cáo và gia tăng tỷ lệ chuyển đổi.
-- + Giúp nhận diện các nhóm khách hàng có khả năng cao rủi ro như chậm thanh toán hoặc không trung thành, từ đó thực hiện các biện pháp phòng ngừa.


WITH customer_behavior AS (
    SELECT
        "customer_id",
        "name_customer",
        COUNT("transaction_id") AS "total_transactions",
        SUM("txn_amount") AS "total_amount",
        AVG("txn_amount") AS "avg_transaction_amount"

    FROM 
        {{ source('final_snowflake', 'final_fact_transactions') }}

    GROUP BY 
        "customer_id", 
        "name_customer"
),

customer_segments AS (
    SELECT
        "name_customer",
        "total_transactions",
        "total_amount",
        "avg_transaction_amount",
        CASE
            WHEN "total_amount" > 8000000 THEN 'High'
            WHEN "total_amount" BETWEEN 5000000 AND 8000000 THEN 'Medium'
            ELSE 'Low'
        END AS "customer_segment"
    
    FROM customer_behavior
)

SELECT
    "name_customer",
    "customer_segment",
    "total_transactions",
    "total_amount",
    "avg_transaction_amount"

FROM customer_segments

WHERE 
    "customer_segment" IN ('High', 'Low')

ORDER BY 
    "customer_segment" ASC;
