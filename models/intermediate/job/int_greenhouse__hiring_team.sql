with hiring_team as (

    select *
    from {{ var('hiring_team') }}
),

greenhouse_user as (

    select *
    from {{ ref('int_greenhouse__user_emails') }}
),

user_info as (

    select
        hiring_team.job_id,
        case when role = 'recruiters' then greenhouse_user.full_name end as recruiter_name,
        case when role = 'hiring_managers' then greenhouse_user.full_name end as hiring_manager_name,
        case when role = 'coordinators' then greenhouse_user.full_name end as coordinator_name,
        case when role = 'sourcers' then greenhouse_user.full_name end as sourcer_name

    from hiring_team join greenhouse_user using(user_id)
),

agg_role_types as (

    select
        job_id,
        {{ fivetran_utils.string_agg('hiring_manager_name', "', '") }} as hiring_managers,
        {{ fivetran_utils.string_agg('sourcer_name', "', '") }} as sourcers,
        {{ fivetran_utils.string_agg('recruiter_name', "', '") }} as recruiters,
        {{ fivetran_utils.string_agg('coordinator_name', "', '") }} as coordinators
        

    from user_info
    group by job_id
)

select * from agg_role_types