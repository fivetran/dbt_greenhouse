{% macro get_application_stage_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": dbt.type_boolean()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "application_id", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "days_in_stage", "datatype": dbt.type_int()},
    {"name": "entered_at", "datatype": dbt.type_timestamp()},
    {"name": "exited_at", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "job_interview_stage_id", "datatype": dbt.type_int()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{% if target.type in ('bigquery', 'snowflake') %}
{{ columns.append( {"name": "current", "datatype": dbt.type_boolean(), "alias": "is_current", "quote": true} ) }}
{% else %}
{{ columns.append( {"name": "current", "datatype": dbt.type_boolean(), "alias": "is_current"} ) }}
{% endif %}

{{ return(columns) }}

{% endmacro %}
