{% macro get_scorecard_question_answer_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "scorecard_question_id", "datatype": dbt.type_int()},
    {"name": "scorecard_id", "datatype": dbt.type_int()},
    {"name": "answer", "datatype": dbt.type_string()},
    {"name": "answer_with_tag", "datatype": dbt.type_string()},
    {"name": "boolean_value", "datatype": "boolean"},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "value", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
