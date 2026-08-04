{% if var('greenhouse_using_job_hiring_manager', True) or var('greenhouse_using_job_owner', True) %}
with hiring_team as (

    select *
    from {{ ref('int_greenhouse__hiring_team') }}
),

job as (
{% else %}
with job as (
{% endif %}

    select *
    from {{ ref('stg_greenhouse__job') }}
),

{% if var('greenhouse_using_job_office', True) %}
job_office as (

    select *
    from {{ ref('int_greenhouse__job_offices') }}
),
{% endif %}

{% if var('greenhouse_using_job_department', True) %}
job_department as (

    select *
    from {{ ref('int_greenhouse__job_departments') }}
),
{% endif %}

final as (

    select
        job.*

        {% if var('greenhouse_using_job_hiring_manager', True) or var('greenhouse_using_job_owner', True) %}
        ,
        hiring_team.hiring_managers,
        hiring_team.sourcers,
        hiring_team.recruiters,
        hiring_team.coordinators
        {% endif %}

        {% if var('greenhouse_using_job_office', True) %}
        ,
        job_office.offices,
        job_office.locations as office_locations
        {% endif %}

        {% if var('greenhouse_using_job_department', True) %}
        ,
        job_department.departments,
        job_department.parent_departments
        {% endif %}

    from job

    {% if var('greenhouse_using_job_hiring_manager', True) or var('greenhouse_using_job_owner', True) %}
    left join hiring_team
        on job.job_id = hiring_team.job_id
        and job.source_relation = hiring_team.source_relation
    {% endif %}

    {% if var('greenhouse_using_job_office', True) %}
    left join job_office
        on job.job_id = job_office.job_id
        and job.source_relation = job_office.source_relation
    {% endif %}

    {% if var('greenhouse_using_job_department', True) %}
    left join job_department
        on job.job_id = job_department.job_id
        and job.source_relation = job_department.source_relation
    {% endif %}
)

select *
from final