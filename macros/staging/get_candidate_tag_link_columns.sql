{% macro get_candidate_tag_link_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "candidate_id", "datatype": dbt.type_int()},
    {"name": "index", "datatype": dbt.type_int()},
    {"name": "tag_name", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
