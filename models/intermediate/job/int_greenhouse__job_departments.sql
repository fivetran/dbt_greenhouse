with job_department as (

    select *
    from {{ var('job_department') }}
),

department as (

    select *
    from {{ var('department') }}
),

grab_parent_department as (

    select 
        sub.*,
        parent.name as parent_department_name

    from department as sub 
        left join department as parent on sub.parent_department_id = parent.department_id
),

agg_departments as (

    select
        job_id,
        {{ fivetran_utils.string_agg("grab_parent_department.name", "', '") }} as department,
        {{ fivetran_utils.string_agg("grab_parent_department.parent_department_name", "', '") }} as parent_department

    from job_department
    join grab_parent_department using(department_id)

    group by job_id
)

select * from 
agg_departments