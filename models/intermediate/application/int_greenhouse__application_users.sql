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

join_user_names as (

    select
        application.*,
        referrer_user.full_name as referrer_name,
        coordinator.full_name as coordinator_name,
        recruiter.full_name as recruiter_name,
        coordinator.email as coordinator_email,
        recruiter.email as recruiter_email

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

)

select *
from join_user_names