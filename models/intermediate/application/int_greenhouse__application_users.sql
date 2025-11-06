with greenhouse_user as (

    select *
    from {{ ref('int_greenhouse__user_emails') }}
),

application as (

    select *
    from {{ ref('stg_greenhouse__application') }}
),

-- necessary users = credited_to_user (ie referrer), prospect_owner
join_user_names as (

    select
        application.*,
        referrer.full_name as referrer_name,
        prospect_owner.full_name as prospect_owner_name

    from application

    left join greenhouse_user as referrer
        on application.credited_to_user_id = referrer.user_id
        and application.source_relation = referrer.source_relation
    left join greenhouse_user as prospect_owner
        on application.prospect_owner_user_id = prospect_owner.user_id
        and application.source_relation = prospect_owner.source_relation

)

select *
from join_user_names