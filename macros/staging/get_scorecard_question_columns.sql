{% macro get_scorecard_question_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": dbt.type_boolean()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "interview_kit_id", "datatype": dbt.type_int()},
    {"name": "active", "datatype": dbt.type_boolean()},
    {"name": "answer_type", "datatype": dbt.type_string()},
    {"name": "question", "datatype": dbt.type_string()},
    {"name": "required", "datatype": dbt.type_boolean()},
    {"name": "sort_order", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
