{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'greenhouse') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('greenhouse_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("greenhouse_database", target.database) }}' || '.'|| '{{ var("greenhouse_schema", "greenhouse") }}' as source_relation
{% endif %}

{%- endmacro %}