{% macro get_job_opening_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "application_id", "datatype": dbt.type_int()},
    {"name": "close_reason_id", "datatype": dbt.type_int()},
    {"name": "closed_at", "datatype": dbt.type_timestamp()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "is_open", "datatype": "boolean"},
    {"name": "job_id", "datatype": dbt.type_int()},
    {"name": "opened_at", "datatype": dbt.type_timestamp()},
    {"name": "opening_id", "datatype": dbt.type_string()},
    {"name": "sort_order", "datatype": dbt.type_int()},
    {"name": "target_start_on", "datatype": "date"},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
