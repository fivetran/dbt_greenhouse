{{ config(enabled=var('greenhouse_using_app_history', True)) }}

with application_history as (

    select 
        application_id,
        new_stage_id,
        new_status,
        updated_at as valid_from,
        coalesce(lead(updated_at) over (partition by application_id order by updated_at asc), {{ dbt_utils.current_timestamp() }})  as valid_until

    from {{ var('application_history') }}
),

application as (

    select *
    from {{ ref('greenhouse__application_enhanced') }}
),

job_stage as (

    select *
    from {{ var('job_stage') }}
),

activity as (

    select *
    from {{ var('activity') }}
),

join_application_history as (

    select 
        application_history.*,
        job_stage.stage_name as new_stage,
        application.full_name,
        application.status as current_status,
        application.recruiter_name,
        application.hiring_managers,
        application.sourced_from, 
        application.sourced_from_type,
        application.job_title,
        application.job_department,
        application.job_parent_department,
        application.job_office,
        application.job_id,
        application.candidate_id

        {% if var('greenhouse_using_eeoc', True) %}
        ,
        application.candidate_gender,
        application.candidate_disability_status,
        application.candidate_race,
        application.candidate_veteran_status
        {% endif %}

    from application_history 
    join application
        on application_history.application_id = application.application_id
    left join job_stage
        on application_history.new_stage_id = job_stage.job_stage_id
),

time_in_stages as (

    select 
        *,
        {{ dbt_utils.datediff('valid_from', 'valid_until', 'day') }} as days_in_stage

    from join_application_history
),

activities_in_stages as (

    select 
        time_in_stages.*,
        sum(case when activity.occurred_at >= valid_from and activity.occurred_at <= valid_until then 1 else 0 end) as count_activities_in_stage

    from time_in_stages
    left join activity on activity.candidate_id = time_in_stages.candidate_id

    -- 18 columns in join_application_history CTE + 4 more if using the eeoc table + 1 days_in_stage column 
    {{ dbt_utils.group_by(23 if var('greenhouse_using_eeoc', True) else 19) }}
)

select *
from activities_in_stages