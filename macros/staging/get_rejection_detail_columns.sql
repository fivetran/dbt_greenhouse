{% macro get_rejection_detail_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "application_id", "datatype": dbt.type_int()},
    {"name": "rejected_by_id", "datatype": dbt.type_int()},
    {"name": "rejection_reason_id", "datatype": dbt.type_int()},
    {"name": "rejected_at", "datatype": dbt.type_timestamp()},
    {"name": "rejection_note_id", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
