with job as (

    select *
    from {{ ref('int_greenhouse__job_info') }}
),

job_applications as (

    select 
        source_relation,
        job_id,
        sum(case when not is_prospect and status = 'active' then 1 else 0 end) as count_active_applications,
        sum(case when not is_prospect and status = 'hired' then 1 else 0 end) as count_hired_applications,
        sum(case when not is_prospect and status = 'rejected' then 1 else 0 end) as count_rejected_applications,

        sum(case when count_interviews > 0 then 1 else 0 end) as count_interviewed_applications,

        sum(case when is_prospect and status = 'active' then 1 else 0 end) as count_active_prospects,
        sum(case when is_prospect and status = 'converted' then 1 else 0 end) as count_converted_prospects,
        sum(case when is_prospect and status = 'rejected' then 1 else 0 end) as count_rejected_prospects

    from {{ ref('greenhouse__application_enhanced') }}

    group by 1, 2
),

job_post as (

    select *
    from {{ ref('stg_greenhouse__job_post') }}
),

{% if var('greenhouse_using_job_post_location', True) %}
job_post_location as (

    select *
    from {{ ref('stg_greenhouse__job_post_location') }}
),
{% endif %}

{% if var('greenhouse_using_job_post_location', True) and var('greenhouse_using_job_office', True) %}
office as (

    select *
    from {{ ref('stg_greenhouse__office') }}
),
{% endif %}

live_job_posts as (

    select
        job_post.source_relation,
        job_post.job_id,
        sum(case when job_post.is_internal then 1 else 0 end) as count_live_internal_posts,
        sum(case when not job_post.is_internal then 1 else 0 end) as count_live_external_posts
        {% if var('greenhouse_using_job_post_location', True) %}
            {% if var('greenhouse_using_job_office', True) %}
        , count(distinct lower(coalesce(job_post_location.plain_text_location, office.office_name))) as count_live_locations
            {% else %}
        , count(distinct lower(job_post_location.plain_text_location)) as count_live_locations
            {% endif %}
        {% else %}
        , 0 as count_live_locations
        {% endif %}

    from job_post
    {% if var('greenhouse_using_job_post_location', True) %}
    left join job_post_location
        on job_post.job_post_id = job_post_location.job_post_id
        and job_post.source_relation = job_post_location.source_relation
        {% if var('greenhouse_using_job_office', True) %}
    left join office
        on job_post_location.office_id = office.office_id
        and job_post_location.source_relation = office.source_relation
        {% endif %}
    {% endif %}

    where job_post.is_live

    group by 1, 2
),

job_openings as (

    select 
        source_relation,
        job_id,
        sum(case when current_status then 1 else 0 end) as count_active_openings,
        sum(case when not current_status then 1 else 0 end) as count_closed_openings,
        sum(case when not current_status and application_id is not null then 1 else 0 end) as count_hired_closed_openings
        
    from {{ ref('stg_greenhouse__opening') }}

    group by 1, 2
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
        and job.source_relation = job_applications.source_relation
    left join live_job_posts
        on job.job_id = live_job_posts.job_id
        and job.source_relation = live_job_posts.source_relation
    left join job_openings
        on job.job_id = job_openings.job_id
        and job.source_relation = job_openings.source_relation
)

select *
from final 
