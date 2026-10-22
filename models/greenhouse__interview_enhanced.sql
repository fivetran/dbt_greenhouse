{{ config(enabled=var('greenhouse_using_interview', True)) }}

with interview as (

    select *
    from {{ ref('int_greenhouse__interview_users') }}
),

job_interview as (

    select *
    from {{ ref('stg_greenhouse__job_interview') }}
),

job_stage as (

    select *
    from {{ ref('stg_greenhouse__job_interview_stage') }}
),

{% if var('greenhouse_using_interview_kit', True) %}
interview_kit as (

    select *
    from {{ ref('stg_greenhouse__interview_kit') }}
),
{% endif %}

-- this has job info!
application as (

    select *
    from {{ ref('int_greenhouse__application_info') }}
),

final as (

    select
        interview.*,
        application.full_name as candidate_name,
        job_stage.stage_name as job_stage,
        application.current_job_stage as application_current_job_stage,
        application.status as current_application_status,
        application.job_title,

        {% if var('greenhouse_using_interview_kit', True) %}
        job_interview.interview_duration_minutes,
        job_interview.requires_scorecard,
        job_interview.scheduling_type,
        interview_kit.anonymize_candidate,
        interview_kit.anonymize_resumes,
        interview_kit.exercises,
        {% endif %}

        {% if var('greenhouse_using_job_hiring_manager', True) and var('greenhouse_using_interviewer', True) %}
        application.hiring_managers like ('%' || interview.interviewer_name || '%')  as interviewer_is_hiring_manager,
        {% endif %}
        {% if var('greenhouse_using_job_hiring_manager', True) %}
        application.hiring_managers,
        {% endif %}
        application.recruiter_name

        {% if var('greenhouse_using_job_office', True) %}
        ,
        application.job_offices
        {% endif %}

        {% if var('greenhouse_using_job_department', True) %}
        ,
        application.job_departments,
        application.job_parent_departments
        {% endif %}

        {% if var('greenhouse_using_eeoc', true) %}
        ,
        application.candidate_gender,
        application.candidate_disability_status,
        application.candidate_race,
        application.candidate_veteran_status
        {% endif %}

    from interview
    left join job_interview
        on interview.job_interview_id = job_interview.job_interview_id
        and interview.source_relation = job_interview.source_relation
    left join job_stage
        on job_interview.job_interview_stage_id = job_stage.job_stage_id
        and job_interview.source_relation = job_stage.source_relation
    {% if var('greenhouse_using_interview_kit', True) %}
    left join interview_kit
        on job_interview.job_interview_id = interview_kit.job_interview_id
        and job_interview.source_relation = interview_kit.source_relation
    {% endif %}
    left join application
        on interview.application_id = application.application_id
        and interview.source_relation = application.source_relation
)

select * from final