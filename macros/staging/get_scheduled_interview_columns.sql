{% macro get_scheduled_interview_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "application_id", "datatype": dbt.type_int()},
    {"name": "job_interview_id", "datatype": dbt.type_int()},
    {"name": "job_id", "datatype": dbt.type_int()},
    {"name": "location", "datatype": dbt.type_string()},
    {"name": "organizer_id", "datatype": dbt.type_int()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "starts_at", "datatype": dbt.type_timestamp()},
    {"name": "ends_at", "datatype": dbt.type_timestamp()},
    {"name": "scheduled_at", "datatype": dbt.type_timestamp()},
    {"name": "availability_received_at", "datatype": dbt.type_timestamp()},
    {"name": "all_day_start_on", "datatype": "date"},
    {"name": "all_day_end_on", "datatype": "date"},
    {"name": "external_event_id", "datatype": dbt.type_string()},
    {"name": "video_conferencing_url", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
