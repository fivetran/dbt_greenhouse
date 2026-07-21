
with base as (

    select *
    from {{ ref('stg_greenhouse__job_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__job_tmp')),
                staging_columns=get_job_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

        {% if var('greenhouse_job_custom_columns', []) != [] %}
        ,
        {% for col in var('greenhouse_job_custom_columns', []) %}{{ adapter.quote(col) if var('fivetran_using_source_casing', false) else col }}{{ ', ' if not loop.last }}{% endfor %}
        {% endif %}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(closed_at as {{ dbt.type_timestamp() }}) as last_opening_closed_at,
        confidential as is_confidential,
        cast(copied_from_id as {{ dbt.type_string() }}) as copied_from_id,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(department_id as {{ dbt.type_string() }}) as department_id,
        cast(id as {{ dbt.type_string() }}) as job_id,
        is_template,
        name as job_title,
        notes,
        cast(opened_at as {{ dbt.type_timestamp() }}) as opened_at,
        cast(requisition_id as {{ dbt.type_string() }}) as requisition_id,
        status,
        cast(updated_at as {{ dbt.type_timestamp() }}) as last_updated_at

        {% if var('greenhouse_job_custom_columns', []) != [] %}
        ,
        {% for col in var('greenhouse_job_custom_columns', []) %}{{ adapter.quote(col) if var('fivetran_using_source_casing', false) else col }}{{ ', ' if not loop.last }}{% endfor %}
        {% endif %}

    from fields
)

select * from final
