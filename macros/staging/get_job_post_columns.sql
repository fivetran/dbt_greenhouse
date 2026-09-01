{% macro get_job_post_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "active", "datatype": "boolean"},
    {"name": "content", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "demographic_question_set_id", "datatype": dbt.type_int()},
    {"name": "featured", "datatype": "boolean"},
    {"name": "first_published_at", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "internal", "datatype": "boolean"},
    {"name": "internal_content", "datatype": dbt.type_string()},
    {"name": "job_board_id", "datatype": dbt.type_int()},
    {"name": "job_id", "datatype": dbt.type_int()},
    {"name": "language_code", "datatype": dbt.type_string()},
    {"name": "live", "datatype": "boolean"},
    {"name": "public_url", "datatype": dbt.type_string()},
    {"name": "title", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
