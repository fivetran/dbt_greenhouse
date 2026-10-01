{% macro get_job_interview_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "job_interview_stage_id", "datatype": dbt.type_int()},
    {"name": "job_id", "datatype": dbt.type_int()},
    {"name": "active", "datatype": "boolean"},
    {"name": "duration", "datatype": dbt.type_int()},
    {"name": "instruction", "datatype": dbt.type_string()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "require_scorecard", "datatype": "boolean"},
    {"name": "scheduling_type", "datatype": dbt.type_string()},
    {"name": "sort_order", "datatype": dbt.type_int()},
    {"name": "summary", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
