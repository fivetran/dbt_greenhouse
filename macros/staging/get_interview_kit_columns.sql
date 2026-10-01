{% macro get_interview_kit_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "job_id", "datatype": dbt.type_int()},
    {"name": "job_interview_id", "datatype": dbt.type_int()},
    {"name": "anonymize_candidate", "datatype": "boolean"},
    {"name": "anonymize_resumes", "datatype": "boolean"},
    {"name": "exercises", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
