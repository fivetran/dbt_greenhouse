with application as (

    select *
    from {{ ref('int_greenhouse__application_info') }}
),

job_posts as (

    select 
        job_id,
        sum(case when is_internal then 1 else 0 end) as count_live_internal_posts,
        sum(case when is_external then 1 else 0 end) as count_live_external_posts,
        count(distinct lower(location_name)) as count_distinct_locations

    from {{ var('job_post') }}

    where is_live

    group by 1
),

-- want to get # open, closed
job_opening as (

    select 
        job_id,
        sum(case when current_status = 'open' then 1 else 0 end) as count_active_openings,
        sum(case when current_status = 'closed' then 1 else 0 end) as count_closed_openings,
        sum(case when current_status = 'closed' and application_id is not null then 1 else 0 end) as count_hired_openings
        
    from {{ var('job_opening') }}

    group by 1
),

-- also wanna get interviews
final as (
select null as n
)

select *
from final 
-- hold off on this until deciding whether or not to focus on jobs vs job openings 