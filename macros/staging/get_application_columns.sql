{% macro get_application_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "candidate_id", "datatype": dbt.type_int()},
    {"name": "last_activity_at", "datatype": dbt.type_timestamp()},
    {"name": "location_address", "datatype": dbt.type_string()},
    {"name": "prospect", "datatype": "boolean"},
    {"name": "rejected_at", "datatype": dbt.type_timestamp()},
    {"name": "source_id", "datatype": dbt.type_int()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "stage_id", "datatype": dbt.type_int()},
    {"name": "coordinator_id", "datatype": dbt.type_int()},
    {"name": "job_id", "datatype": dbt.type_int()},
    {"name": "job_post_id", "datatype": dbt.type_int()},
    {"name": "recruiter_id", "datatype": dbt.type_int()},
    {"name": "referrer_id", "datatype": dbt.type_int()},
    {"name": "agency_note_id", "datatype": dbt.type_int()},
    {"name": "needs_decision", "datatype": "boolean"},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
