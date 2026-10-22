{{ config(enabled=var('greenhouse_using_scorecard_question', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__scorecard_question_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__scorecard_question_tmp')),
                staging_columns=get_scorecard_question_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as scorecard_question_id,
        cast(interview_kit_id as {{ dbt.type_string() }}) as interview_kit_id,
        active as is_active,
        answer_type,
        question as question_text,
        required as is_required,
        cast(sort_order as {{ dbt.type_int() }}) as sort_order,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
