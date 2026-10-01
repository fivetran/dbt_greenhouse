{% macro get_scorecard_question_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "interview_kit_id", "datatype": dbt.type_int()},
    {"name": "active", "datatype": "boolean"},
    {"name": "answer_type", "datatype": dbt.type_string()},
    {"name": "question", "datatype": dbt.type_string()},
    {"name": "required", "datatype": "boolean"},
    {"name": "sort_order", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
