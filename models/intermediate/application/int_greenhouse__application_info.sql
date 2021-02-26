with application as (

    select *
    from {{ ref('int_greenhouse__application_users') }}
),

candidate as (

    select *
    from {{ ref('int_greenhouse__candidate_users') }}
),

candidate_tag as (

    select *
    from {{ ref('int_greenhouse__candidate_tags') }}
),

job_stage as (

    select *
    from {{ var('job_stage') }}
),

source as (

    select *
    from {{ var('source') }}
),

activity as (

    select 
        candidate_id,
        count(*) as count_activities

    from {{ var('activity') }}
    group by 1
),

-- note: prospect applications can have multiple jobs, while canddiate ones are 1:1
job as (

    select *
    from {{ ref('int_greenhouse__job_info') }}
),

job_application as (

    select *
    from {{ var('job_application') }}
),

{% if var('greenhouse_using_eeoc', true) %}
eeoc as (

    select *
    from {{ var('eeoc') }}
),
{% endif %}

{% if var('greenhouse_using_prospects', true) %}
prospect_pool as (

    select *
    from {{ var('prospect_pool') }}
),

prospect_stage as (

    select *
    from {{ var('prospect_stage') }}
),
{% endif %}

join_info as (

    select 
        application.*,
        -- remove/rename overlapping columns + get custom columns
        {{ dbt_utils.star(from=ref('int_greenhouse__candidate_users'), 
            except=["candidate_id", "new_candidate_id", "created_at", "_fivetran_synced", "last_activity_at"], 
            relation_alias="candidate") }}
        ,
        candidate.created_at as candidate_created_at,
        candidate_tag.tags as candidate_tags,
        job_stage.stage_name as current_job_stage,
        source.source_name as sourced_from,
        source.source_type_name as sourced_from_type,
        activity.count_activities,

        job.job_title,
        job.offices as job_offices,
        job.departments as job_departments,
        job.parent_departments as job_parent_departments,
        job.status as job_status,
        job.hiring_managers,
        job.job_id,
        job.requisition_id as job_requisition_id,
        job.sourcers as job_sourcers

        {% if var('greenhouse_using_prospects', true) %}
        ,
        prospect_pool.prospect_pool_name as prospect_pool,
        prospect_stage.prospect_stage_name as prospect_stage
        {% endif %}

        {% if var('greenhouse_using_eeoc', true) %}
        ,
        eeoc.gender_description as candidate_gender,
        eeoc.disability_status_description as candidate_disability_status,
        eeoc.race_description as candidate_race,
        eeoc.veteran_status_description as candidate_veteran_status
        {% endif %}


    from application
    left join candidate
        on application.candidate_id = candidate.candidate_id
    left join candidate_tag
        on application.candidate_id = candidate_tag.candidate_id
    left join job_stage
        on application.current_stage_id = job_stage.job_stage_id
    left join source
        on application.source_id = source.source_id
    left join activity
        on activity.candidate_id = candidate.candidate_id
    left join job_application
        on application.application_id = job_application.application_id
    left join job
        on job_application.job_id = job.job_id

    {% if var('greenhouse_using_eeoc', true) %}
    left join eeoc 
        on eeoc.application_id = application.application_id
    {% endif -%}


    {% if var('greenhouse_using_prospects', true) %}
    left join prospect_pool 
        on prospect_pool.prospect_pool_id = application.prospect_pool_id
    left join prospect_stage
        on prospect_stage.prospect_stage_id = application.prospect_stage_id
    {% endif %}
),

final as (

    select 
        *,
        {{ dbt_utils.surrogate_key(['application_id', 'job_id']) }} as application_job_key
    
    from join_info
)

select *
from final