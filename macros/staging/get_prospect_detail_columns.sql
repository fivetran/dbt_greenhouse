{% macro get_prospect_detail_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "application_id", "datatype": dbt.type_int()},
    {"name": "department_id", "datatype": dbt.type_int()},
    {"name": "office_id", "datatype": dbt.type_int()},
    {"name": "pool_id", "datatype": dbt.type_int()},
    {"name": "pool_stage_id", "datatype": dbt.type_int()},
    {"name": "prospect_owner_id", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
