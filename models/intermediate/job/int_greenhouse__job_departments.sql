{{ config(enabled=var('greenhouse_using_job_department', True)) }}

with job as (

    select *
    from {{ ref('stg_greenhouse__job') }}
),

department as (

    select *
    from {{ ref('stg_greenhouse__department') }}
),

join_parent_department as (

    select
        sub.*,
        parent.name as parent_department_name

    from department as sub
        left join department as parent
            on sub.parent_department_id = parent.department_id
            and sub.source_relation = parent.source_relation
),

agg_departments as (

    select
        job.source_relation,
        job.job_id,
        join_parent_department.name as departments,
        join_parent_department.parent_department_name as parent_departments

    from job
    left join join_parent_department
        on job.department_id = join_parent_department.department_id
        and job.source_relation = join_parent_department.source_relation
)

select * from agg_departments