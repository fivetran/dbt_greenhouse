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

    select *,
    from {{ var('job_stage') }}
),

source as (

    select *
    from {{ var('source') }}
),

activity as (

    select 
        candidate_id,
        count(*) as count_activites

    from {{ var('activity') }}
    group by 1
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

final as (

    select 
        application.*,
        {{ dbt_utils.star(from=ref('int_greenhouse__candidate_users'), 
            except=["candidate_id", "new_candidate_id", "created_at", "_fivetran_synced", "last_activity_at"], 
            relation_alias="candidate") }}
        ,
        candidate.created_at as candidate_created_at,
        candidate_tag.tags as candidate_tags,
        job_stage.stage_name as current_job_stage,
        source.source_name as sourced_from,
        source.source_type_name as sourced_from_type,
        activity.count_activites

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
)

select *
from final

-- job stuff - bring in here or in the final model?
-- interview metrics! bring in the final model maybe..
-- pronouns -- do this in another intermediate model