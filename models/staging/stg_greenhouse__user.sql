
with base as (

    select *
    from {{ ref('stg_greenhouse__user_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__user_tmp')),
                staging_columns=get_user_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(agency_id as {{ dbt.type_string() }}) as agency_id,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        deactivated as is_disabled,
        cast(employee_id as {{ dbt.type_string() }}) as employee_id,
        first_name || ' ' || last_name as full_name,
        cast(id as {{ dbt.type_string() }}) as user_id,
        job_title,
        primary_email,
        site_admin as is_site_admin,
        cast(updated_at as {{ dbt.type_timestamp() }}) as last_updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
