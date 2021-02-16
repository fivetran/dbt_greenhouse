with greenhouse_user as (

    select *
    from {{ ref('int_greenhouse__user_emails') }}
),

application as (

    select *
    from {{ var('application') }}
),

-- necessary users = credited_to_user_id, prospect_owner_user_id
grab_user_names as (

    select
        application.*,
        credited_to_user.first_name as credited_to_user_first_name,
        credited_to_user.last_name as credited_to_user_last_name,
        prospect_owner.first_name as prospect_owner_first_name,
        prospect_owner.last_name as prospect_owner_last_name,

        prospect_owner.emails as prospect_owner_emails

    from application

    left join greenhouse_user as credited_to_user
        on application.credited_to_user_id = credited_to_user.user_id
    left join greenhouse_user as prospect_owner
        on application.prospect_owner_user_id = prospect_owner.user_id

)

select *
from grab_user_names