{{ config(enabled=var('greenhouse_using_scorecard_question', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__scorecard_question_answer_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__scorecard_question_answer_tmp')),
                staging_columns=get_scorecard_question_answer_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as scorecard_question_answer_id,
        cast(scorecard_question_id as {{ dbt.type_string() }}) as scorecard_question_id,
        cast(scorecard_id as {{ dbt.type_string() }}) as scorecard_id,
        answer,
        answer_with_tag,
        boolean_value,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        value

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
