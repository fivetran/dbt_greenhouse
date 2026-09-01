{% macro get_job_office_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "index", "datatype": dbt.type_int()},
    {"name": "job_id", "datatype": dbt.type_int()},
    {"name": "office_id", "datatype": dbt.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
