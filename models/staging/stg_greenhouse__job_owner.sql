{{ config(enabled=var('greenhouse_using_job_hiring_team', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__job_owner_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__job_owner_tmp')),
                staging_columns=get_job_owner_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as id,
        cast(job_id as {{ dbt.type_string() }}) as job_id,
        cast(user_id as {{ dbt.type_string() }}) as user_id,
        type,
        responsible,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

    from fields
)

select * from final
