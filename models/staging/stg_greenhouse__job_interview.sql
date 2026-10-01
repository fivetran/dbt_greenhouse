{{ config(enabled=var('greenhouse_using_interview', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__job_interview_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__job_interview_tmp')),
                staging_columns=get_job_interview_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as job_interview_id,
        cast(job_interview_stage_id as {{ dbt.type_string() }}) as job_interview_stage_id,
        cast(job_id as {{ dbt.type_string() }}) as job_id,
        active as is_active,
        cast(duration as {{ dbt.type_int() }}) as interview_duration_minutes,
        instruction,
        name,
        require_scorecard as requires_scorecard,
        scheduling_type,
        cast(sort_order as {{ dbt.type_int() }}) as sort_order,
        summary,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
