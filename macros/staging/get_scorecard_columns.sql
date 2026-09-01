{% macro get_scorecard_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "application_id", "datatype": dbt.type_int()},
    {"name": "candidate_rating", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "interview_kit_id", "datatype": dbt.type_int()},
    {"name": "interviewed_at", "datatype": dbt.type_timestamp()},
    {"name": "interviewer_id", "datatype": dbt.type_int()},
    {"name": "notes", "datatype": dbt.type_string()},
    {"name": "notes_with_tags", "datatype": dbt.type_string()},
    {"name": "private_notes", "datatype": dbt.type_string()},
    {"name": "private_notes_with_tags", "datatype": dbt.type_string()},
    {"name": "public_notes", "datatype": dbt.type_string()},
    {"name": "public_notes_with_tags", "datatype": dbt.type_string()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "submitted_at", "datatype": dbt.type_timestamp()},
    {"name": "submitter_id", "datatype": dbt.type_int()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
