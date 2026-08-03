
with base as (

    select * 
    from {{ ref('stg_greenhouse__scorecard_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__scorecard_tmp')),
                staging_columns=get_scorecard_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}
        
    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(application_id as {{ dbt.type_string() }}) as application_id,
        candidate_rating,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(id as {{ dbt.type_string() }}) as scorecard_id,
        cast(interview_kit_id as {{ dbt.type_string() }}) as interview_kit_id,
        cast(interviewed_at as {{ dbt.type_timestamp() }}) as interviewed_at,
        cast(interviewer_id as {{ dbt.type_string() }}) as interviewer_id,
        notes,
        notes_with_tags,
        private_notes,
        private_notes_with_tags,
        public_notes,
        public_notes_with_tags,
        status,
        cast(submitted_at as {{ dbt.type_timestamp() }}) as submitted_at,
        cast(submitter_id as {{ dbt.type_string() }}) as submitted_by_user_id,
        cast(updated_at as {{ dbt.type_timestamp() }}) as last_updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
