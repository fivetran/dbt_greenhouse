with hiring_team as (

    select *
    from {{ ref('int_greenhouse__hiring_team') }}
),

job as (

    select *
    from {{ var('job') }}
),

job_office as (

    select *
    from {{ ref('int_greenhouse__job_offices') }}
),

job_department as (

    select *
    from {{ ref('int_greenhouse__job_departments') }}
),

final as (

    select 
        job.*,
        hiring_team.hiring_managers,
        hiring_team.sourcers,
        hiring_team.recruiters,
        hiring_team.coordinators,

        -- note: these can be plural (should we add 's' to these columns?) or remove the s's from hiring_team
        job_office.offices,
        job_office.locations as office_locations,
        job_department.departments,
        job_department.parent_departments

    from job 
    left join hiring_team 
        on job.job_id = hiring_team.job_id
    left join job_office 
        on job.job_id = job_office.job_id
    left join job_department
        on job.job_id = job_department.job_id
)

select *
from final