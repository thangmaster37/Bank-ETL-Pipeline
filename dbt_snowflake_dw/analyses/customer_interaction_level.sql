
-- Phân tích mức độ tương tác của khách hàng dựa trên các kênh giao dịch, đánh giá chất lượng và số lượng tương tác của họ
-- Mục tiêu của nghiên cứu:
-- + Phân tích hiệu suất kênh: Xác định xem các khách hàng tương tác qua kênh nào nhiều nhất.
-- + Đánh giá trải nghiệm: Dựa trên điểm đánh giá tương tác của khách hàng, chúng ta muốn hiểu mức độ hài lòng của họ với từng kênh.
-- + Xếp hạng khách hàng: Xếp hạng khách hàng dựa trên điểm đánh giá trung bình trong mỗi kênh, từ đó tìm ra khách hàng tiềm năng hoặc cần cải thiện.


WITH interaction_data AS (
    SELECT
        "interaction_id",
        "date_id",
        "date_interaction",
        "customer_id",
        "name_customer",
        "house_number_customer",
        "street_name_customer",
        "city_customer",
        "state_customer",
        "channel_id",
        "channel_interaction",
        "interaction_rating"
    FROM
        {{ source('final_snowflake', 'final_fact_customer_interactions') }}
)

SELECT
    "name_customer" AS "Customer Name",
    "city_customer" AS "City",
    "channel_interaction" AS "Interaction Channel",
    COUNT("interaction_id") AS "Total Interactions",
    AVG("interaction_rating") AS "Average Rating",
    RANK() OVER (PARTITION BY "channel_interaction" ORDER BY AVG("interaction_rating") DESC) AS "Rank in Channel"
FROM
    interaction_data
WHERE
    "date_interaction" BETWEEN '2024-01-01' AND '2024-12-31' -- Chỉ lấy các tương tác trong năm 2024
GROUP BY
    "name_customer",
    "city_customer",
    "channel_interaction"
HAVING
    COUNT("interaction_id") > 3 -- Chỉ những khách hàng có hơn 3 tương tác mới được tính
ORDER BY
    "Rank in Channel" ASC;
