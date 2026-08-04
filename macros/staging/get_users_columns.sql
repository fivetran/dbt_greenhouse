{% macro get_users_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "agency_id", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "deactivated", "datatype": "boolean"},
    {"name": "employee_id", "datatype": dbt.type_string()},
    {"name": "first_name", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "job_title", "datatype": dbt.type_string()},
    {"name": "last_name", "datatype": dbt.type_string()},
    {"name": "primary_email", "datatype": dbt.type_string()},
    {"name": "site_admin", "datatype": "boolean"},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
