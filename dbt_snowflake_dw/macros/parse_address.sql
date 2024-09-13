
-- Hàm để phân tích address thành house_number, street_name, apartment/suite
{% macro parse_address(input_address) %}
    -- Tách house_number (là phần đầu tiên của chuỗi, số trước tiên)
    CASE
        WHEN REGEXP_SUBSTR("{{ input_address }}", '^\\d+') IS NOT NULL 
        THEN REGEXP_SUBSTR("{{ input_address }}", '^\\d+')
        ELSE NULL
    END AS "house_number",

    -- Tách street_name (phần còn lại sau house_number, tới trước các đơn vị căn hộ)
    CASE
        WHEN REGEXP_SUBSTR("{{ input_address }}", '^\\d+\\s+([^\\d]+)((Apt|Suite)\.?\\s+\\d+)?$', 1, 1, 'e', 1) IS NOT NULL
        THEN LOWER(TRIM(REGEXP_SUBSTR("{{ input_address }}", '^\\d+\\s+([^\\d]+)((Apt|Suite)\.?\\s+\\d+)?$', 1, 1, 'e', 1)))
        ELSE NULL
    END AS "street_name",

    -- Tách apartment hoặc suite (phần có chứa "Apt" hoặc "Suite" nếu có)
    CASE
        WHEN REGEXP_SUBSTR("{{ input_address }}", '(Apt|Suite)\.?\\s+\\d+') IS NOT NULL
        THEN LOWER(TRIM(REGEXP_SUBSTR("{{ input_address }}", '(Apt|Suite)\.?\\s+\\d+')))
        ELSE NULL
    END AS "apartment_suite"
{% endmacro %}
