with job_stage as (

    select *
    from {{ var('job_stage') }}
),

grab_stage as (

    select 
        interview.*,
        job_stage.stage_name
        {# job_stage.job_id #}
        
    from interview left join job_stage using(job_stage_id)
)