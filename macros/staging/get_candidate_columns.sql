{% macro get_candidate_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "company", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "first_name", "datatype": dbt.type_string()},
    {"name": "last_name", "datatype": dbt.type_string()},
    {"name": "private", "datatype": "boolean"},
    {"name": "last_activity_at", "datatype": dbt.type_timestamp()},
    {"name": "title", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "can_email", "datatype": "boolean"},
    {"name": "preferred_name", "datatype": dbt.type_string()},
    {"name": "time_zone", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
