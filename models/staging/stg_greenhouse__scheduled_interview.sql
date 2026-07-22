
with base as (

    select *
    from {{ ref('stg_greenhouse__scheduled_interview_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__scheduled_interview_tmp')),
                staging_columns=get_scheduled_interview_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as scheduled_interview_id,
        cast(application_id as {{ dbt.type_string() }}) as application_id,
        cast(job_interview_id as {{ dbt.type_string() }}) as interview_id,
        cast(job_id as {{ dbt.type_string() }}) as job_id,
        location,
        cast(organizer_id as {{ dbt.type_string() }}) as organizer_user_id,
        status,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as last_updated_at,
        cast(starts_at as {{ dbt.type_timestamp() }}) as start_at,
        cast(ends_at as {{ dbt.type_timestamp() }}) as end_at,
        cast(scheduled_at as {{ dbt.type_timestamp() }}) as scheduled_at,
        cast(availability_received_at as {{ dbt.type_timestamp() }}) as availability_received_at,
        cast(all_day_start_on as date) as all_day_start_on,
        cast(all_day_end_on as date) as all_day_end_on,
        external_event_id,
        video_conferencing_url

    from fields
)

select * from final
