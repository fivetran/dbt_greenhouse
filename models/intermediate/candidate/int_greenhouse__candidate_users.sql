with greenhouse_user as (

    select *
    from {{ ref('int_greenhouse__user_emails') }}
),

candidate as (

    select *
    from {{ ref('int_greenhouse__candidate_contacts') }}
),

-- necessary users = coordinator_user, recruiter_user
grab_user_names as (

    select
        candidate.*,
        coordinator.first_name as coordinator_first_name,
        coordinator.last_name as coordinator_last_name,
        recruiter.first_name as referrer_first_name,
        recruiter.last_name as referrer_last_name,
        coordinator.emails as coordinator_emails,
        recruiter.emails as recruiter_emails

    from candidate

    left join greenhouse_user as coordinator
        on candidate.coordinator_user_id = coordinator.user_id
    left join greenhouse_user as recruiter
        on candidate.recruiter_user_id = recruiter.user_id 

)

select *
from grab_user_names