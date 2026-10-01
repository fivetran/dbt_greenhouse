{% macro get_job_candidate_attribute_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "job_id", "datatype": dbt.type_int()},
    {"name": "candidate_attribute_type_id", "datatype": dbt.type_int()},
    {"name": "active", "datatype": "boolean"},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "sort_order", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
