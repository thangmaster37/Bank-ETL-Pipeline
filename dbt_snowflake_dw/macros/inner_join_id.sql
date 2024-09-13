
-- Hàm dùng để join các bảng fact với các bảng dim dựa trên ID
{% macro inner_join_id(resources, source_table, table1, table2, column1, column2) %}
    
    INNER JOIN 
        {{ source(resources, source_table) }} AS "{{ table2 }}"
        ON "{{ table1 }}"."{{ column1 }}" = "{{ table2 }}"."{{ column2 }}"

{% endmacro %}
