with greenhouse_user as (

    select *
    from {{ ref('int_greenhouse__user_emails') }}
),

application as (

    select *
    from {{ ref('stg_greenhouse__application') }}
),

join_user_names as (

    select
        application.*,
        referrer.full_name as referrer_name,
        coordinator.full_name as coordinator_name,
        recruiter.full_name as recruiter_name,
        coordinator.email as coordinator_email,
        recruiter.email as recruiter_email

    from application

    left join greenhouse_user as referrer
        on application.referrer_id = referrer.user_id
        and application.source_relation = referrer.source_relation

    left join greenhouse_user as coordinator
        on application.coordinator_id = coordinator.user_id
        and application.source_relation = coordinator.source_relation

    left join greenhouse_user as recruiter
        on application.recruiter_id = recruiter.user_id
        and application.source_relation = recruiter.source_relation

)

select *
from join_user_names