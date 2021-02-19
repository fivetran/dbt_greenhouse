with job as (

    select *
    from {{ ref('int_greenhouse__job_info') }}
),

job_applications as (

    select 
        job_id,
        sum(case when not is_prospect and status = 'active' then 1 else 0 end) as count_active_applications,
        sum(case when not is_prospect and status = 'hired' then 1 else 0 end) as count_hired_applications,
        sum(case when not is_prospect and status = 'rejected' then 1 else 0 end) as count_rejected_applications,

        sum(case when count_interviews > 0 then 1 else 0 end) as count_interviewed_applications,

        sum(case when is_prospect and status = 'active' then 1 else 0 end) as count_active_prospects,
        sum(case when is_prospect and status = 'converted' then 1 else 0 end) as count_converted_prospects,
        sum(case when is_prospect and status = 'rejected' then 1 else 0 end) as count_rejected_prospects

    from {{ ref('greenhouse__application_enhanced') }}

    group by 1
),

live_job_posts as (

    select 
        job_id,
        sum(case when is_internal then 1 else 0 end) as count_live_internal_posts,
        sum(case when is_external then 1 else 0 end) as count_live_external_posts,
        count(distinct lower(location_name)) as count_live_locations

    from {{ var('job_post') }}

    where is_live

    group by 1
),

job_openings as (

    select 
        job_id,
        sum(case when current_status = 'open' then 1 else 0 end) as count_active_openings,
        sum(case when current_status = 'closed' then 1 else 0 end) as count_closed_openings,
        sum(case when current_status = 'closed' and application_id is not null then 1 else 0 end) as count_hired_closed_openings
        
    from {{ var('job_opening') }}

    group by 1
),

final as (

    select 
        job.*,
        coalesce(job_applications.count_active_applications, 0) as count_active_applications,
        coalesce(job_applications.count_hired_applications, 0) as count_hired_applications,
        coalesce(job_applications.count_rejected_applications, 0) as count_rejected_applications,
        coalesce(job_applications.count_interviewed_applications, 0) as count_interviewed_applications,
        coalesce(job_applications.count_active_prospects, 0) as count_active_prospects,
        coalesce(job_applications.count_converted_prospects, 0) as count_converted_prospects,
        coalesce(job_applications.count_rejected_prospects, 0) as count_rejected_prospects,

        coalesce(job_openings.count_active_openings, 0) as count_active_openings,
        coalesce(job_openings.count_closed_openings, 0) as count_closed_openings,
        coalesce(job_openings.count_hired_closed_openings, 0) as count_hired_closed_openings,

        coalesce(live_job_posts.count_live_internal_posts, 0) as count_live_internal_posts,
        coalesce(live_job_posts.count_live_external_posts, 0) as count_live_external_posts,
        coalesce(live_job_posts.count_live_locations, 0) as count_live_locations



    from job 
    left join job_applications 
        on job.job_id = job_applications.job_id
    left join live_job_posts
        on job.job_id = live_job_posts.job_id
    left join job_openings
        on job.job_id = job_openings.job_id
)

select *
from final 
