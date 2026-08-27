{{ config(enabled=var('greenhouse_using_interviewer', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__interviewer_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__interviewer_tmp')),
                staging_columns=get_interviewer_columns()
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
        cast(user_id as {{ dbt.type_string() }}) as interviewer_user_id,
        cast(interview_id as {{ dbt.type_string() }}) as scheduled_interview_id,
        cast(scorecard_id as {{ dbt.type_string() }}) as scorecard_id,
        email,
        response_status,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
