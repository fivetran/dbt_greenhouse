{% macro get_rejection_reason_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "type_id", "datatype": dbt.type_int()},
    {"name": "type_key", "datatype": dbt.type_string()},
    {"name": "type_name", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
