{% macro get_user_email_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "email", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "user_id", "datatype": dbt.type_int()},
    {"name": "verification_token_sent_at", "datatype": dbt.type_timestamp()},
    {"name": "verified", "datatype": "boolean"}
] %}

{{ return(columns) }}

{% endmacro %}
