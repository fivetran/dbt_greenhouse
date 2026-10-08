{% macro get_note_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "user_id", "datatype": dbt.type_int()},
    {"name": "candidate_id", "datatype": dbt.type_int()},
    {"name": "application_id", "datatype": dbt.type_int()},
    {"name": "body", "datatype": dbt.type_string()},
    {"name": "body_with_tags", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "email_attachment_file_names", "datatype": dbt.type_string()},
    {"name": "email_from", "datatype": dbt.type_string()},
    {"name": "email_to", "datatype": dbt.type_string()},
    {"name": "email_cc", "datatype": dbt.type_string()},
    {"name": "import_hash", "datatype": dbt.type_string()},
    {"name": "subject", "datatype": dbt.type_string()},
    {"name": "type", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "visibility", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
