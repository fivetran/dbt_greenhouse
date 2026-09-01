
with base as (

    select *
    from {{ ref('stg_greenhouse__candidate_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__candidate_tmp')),
                staging_columns=get_candidate_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

        {% if var('greenhouse_candidate_custom_columns', []) != [] %}
        ,
        {{ var('greenhouse_candidate_custom_columns', [] )  | join(', ') }}
        {% endif %}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as candidate_id,
        company as current_company,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        first_name || ' ' || last_name as full_name,
        title as current_title,
        cast(updated_at as {{ dbt.type_timestamp() }}) as last_updated_at,
        cast(last_activity_at as {{ dbt.type_timestamp() }}) as last_activity_at,
        private as is_private,
        can_email,
        preferred_name,
        time_zone

        {% if var('greenhouse_candidate_custom_columns', []) != [] %}
        ,
        {{ var('greenhouse_candidate_custom_columns', [] )  | join(', ') }}
        {% endif %}

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
