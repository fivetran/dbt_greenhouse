
with base as (

    select *
    from {{ ref('stg_greenhouse__application_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__application_tmp')),
                staging_columns=get_application_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

        {% if var('greenhouse_application_custom_columns', []) != [] %}
        ,
        {% for col in var('greenhouse_application_custom_columns', []) %}{{ adapter.quote(col) if var('fivetran_using_source_casing', false) else col }}{{ ', ' if not loop.last }}{% endfor %}
        {% endif %}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as application_id,
        cast(candidate_id as {{ dbt.type_string() }}) as candidate_id,
        cast(last_activity_at as {{ dbt.type_timestamp() }}) as last_activity_at,
        location_address,
        prospect as is_prospect,
        cast(rejected_at as {{ dbt.type_timestamp() }}) as rejected_at,
        cast(source_id as {{ dbt.type_string() }}) as source_id,
        status,
        cast(stage_id as {{ dbt.type_string() }}) as stage_id,
        cast(coordinator_id as {{ dbt.type_string() }}) as coordinator_id,
        cast(job_id as {{ dbt.type_string() }}) as job_id,
        cast(job_post_id as {{ dbt.type_string() }}) as job_post_id,
        cast(recruiter_id as {{ dbt.type_string() }}) as recruiter_id,
        cast(referrer_id as {{ dbt.type_string() }}) as referrer_id,
        cast(agency_note_id as {{ dbt.type_string() }}) as agency_note_id,
        needs_decision,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

        {% if var('greenhouse_application_custom_columns', []) != [] %}
        ,
        {% for col in var('greenhouse_application_custom_columns', []) %}{{ adapter.quote(col) if var('fivetran_using_source_casing', false) else col }}{{ ', ' if not loop.last }}{% endfor %}
        {% endif %}

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
