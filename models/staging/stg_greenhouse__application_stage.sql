{{ config(enabled=var('greenhouse_using_application_stage', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__application_stage_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__application_stage_tmp')),
                staging_columns=get_application_stage_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as application_stage_id,
        cast(application_id as {{ dbt.type_string() }}) as application_id,
        cast(job_interview_stage_id as {{ dbt.type_string() }}) as job_interview_stage_id,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        is_current,
        cast(days_in_stage as {{ dbt.type_int() }}) as days_in_stage,
        cast(entered_at as {{ dbt.type_timestamp() }}) as entered_at,
        cast(exited_at as {{ dbt.type_timestamp() }}) as exited_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
