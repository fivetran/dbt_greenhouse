{{ config(enabled=var('greenhouse_using_job_hiring_team', True)) }}

with job_hiring_manager as (

    select *
    from {{ ref('stg_greenhouse__job_hiring_manager') }}
),

job_owner as (

    select *
    from {{ ref('stg_greenhouse__job_owner') }}
),

greenhouse_user as (

    select *
    from {{ ref('int_greenhouse__user_emails') }}
),

combined as (

    select
        source_relation,
        job_id,
        user_id,
        'hiring_manager' as role

    from job_hiring_manager

    union all

    select
        source_relation,
        job_id,
        user_id,
        type as role

    from job_owner
),

user_info as (

    select
        combined.source_relation,
        combined.job_id,
        case when combined.role = 'hiring_manager' then greenhouse_user.full_name end as hiring_manager_name,
        case when combined.role = 'sourcer' then greenhouse_user.full_name end as sourcer_name,
        case when combined.role = 'recruiter' then greenhouse_user.full_name end as recruiter_name,
        case when combined.role = 'coordinator' then greenhouse_user.full_name end as coordinator_name

    from combined
    join greenhouse_user
        on combined.user_id = greenhouse_user.user_id
        and combined.source_relation = greenhouse_user.source_relation
),

agg_role_types as (

    select
        source_relation,
        job_id,
        {{ fivetran_utils.string_agg('hiring_manager_name', "', '") }} as hiring_managers,
        {{ fivetran_utils.string_agg('sourcer_name', "', '") }} as sourcers,
        {{ fivetran_utils.string_agg('recruiter_name', "', '") }} as recruiters,
        {{ fivetran_utils.string_agg('coordinator_name', "', '") }} as coordinators

    from user_info
    group by 1, 2
)

select * from agg_role_types
