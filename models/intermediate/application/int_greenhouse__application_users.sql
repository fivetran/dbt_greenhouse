with greenhouse_user as (

    select *
    from {{ ref('int_greenhouse__user_emails') }}
),

application as (

    select *
    from {{ ref('stg_greenhouse__application') }}
),

referrer as (

    select *
    from {{ ref('stg_greenhouse__referrer') }}
),

{% if var('greenhouse_using_prospect_detail', True) %}
prospect_detail as (

    select *
    from {{ ref('stg_greenhouse__prospect_detail') }}
),

prospect_pool as (

    select *
    from {{ ref('stg_greenhouse__prospect_pool') }}
),

prospect_pool_stage as (

    select *
    from {{ ref('stg_greenhouse__prospect_pool_stage') }}
),
{% endif %}

{% if var('greenhouse_using_rejection_detail', True) %}
rejection_detail as (

    select *
    from {{ ref('stg_greenhouse__rejection_detail') }}
),

{% if var('greenhouse_using_rejection_reason', True) %}
rejection_reason as (

    select *
    from {{ ref('stg_greenhouse__rejection_reason') }}
),
{% endif %}
{% endif %}

join_user_names as (

    select
        application.*,
        referrer_user.full_name as referrer_name,
        coordinator.full_name as coordinator_name,
        recruiter.full_name as recruiter_name,
        coordinator.email as coordinator_email,
        recruiter.email as recruiter_email

        {% if var('greenhouse_using_prospect_detail', True) %}
        ,
        prospect_pool.prospect_pool_id as prospect_pool_id,
        prospect_pool_stage.prospect_stage_id as prospect_pool_stage_id,
        prospect_detail.prospect_owner_id as prospect_owner_id,
        prospect_owner.full_name as prospect_owner_name
        {% endif %}

        {% if var('greenhouse_using_rejection_detail', True) %}
        ,
        rejection_detail.rejection_reason_id as rejection_reason_id,
        rejection_detail.rejected_by_id as rejected_by_id
        {% if var('greenhouse_using_rejection_reason', True) %}
        ,
        rejection_reason.rejection_reason_name as rejection_reason_name,
        rejection_reason.rejection_reason_type_name as rejection_reason_type_name
        {% endif %}
        {% endif %}

    from application

    left join referrer
        on application.referrer_id = referrer.referrer_id
        and application.source_relation = referrer.source_relation

    left join greenhouse_user as referrer_user
        on referrer.user_id = referrer_user.user_id
        and referrer.source_relation = referrer_user.source_relation

    left join greenhouse_user as coordinator
        on application.coordinator_id = coordinator.user_id
        and application.source_relation = coordinator.source_relation

    left join greenhouse_user as recruiter
        on application.recruiter_id = recruiter.user_id
        and application.source_relation = recruiter.source_relation

    {% if var('greenhouse_using_prospect_detail', True) %}
    left join prospect_detail
        on application.application_id = prospect_detail.application_id
        and application.source_relation = prospect_detail.source_relation

    left join prospect_pool
        on prospect_detail.pool_id = prospect_pool.prospect_pool_id
        and prospect_detail.source_relation = prospect_pool.source_relation

    left join prospect_pool_stage
        on prospect_detail.pool_stage_id = prospect_pool_stage.prospect_stage_id
        and prospect_detail.source_relation = prospect_pool_stage.source_relation

    left join greenhouse_user as prospect_owner
        on prospect_detail.prospect_owner_id = prospect_owner.user_id
        and prospect_detail.source_relation = prospect_owner.source_relation
    {% endif %}

    {% if var('greenhouse_using_rejection_detail', True) %}
    left join rejection_detail
        on application.application_id = rejection_detail.application_id
        and application.source_relation = rejection_detail.source_relation

    {% if var('greenhouse_using_rejection_reason', True) %}
    left join rejection_reason
        on rejection_detail.rejection_reason_id = rejection_reason.rejection_reason_id
        and rejection_detail.source_relation = rejection_reason.source_relation
    {% endif %}
    {% endif %}

)

select *
from join_user_names