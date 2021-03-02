with application as (

    select *
    from {{ ref('int_greenhouse__application_info') }}
),

interview_metrics as (

    select 
        application_id,
        max(interviewer_is_hiring_manager) as has_interviewed_w_hiring_manager,
        count(distinct scheduled_interview_id) as count_interviews,
        count(distinct scorecard_id) as count_interview_scorecards,
        count(distinct interviewer_user_id) as count_distinct_interviewers,
        max(start_at) as latest_interview_scheduled_at

    from {{ ref('greenhouse__interview_enhanced') }}

    group by 1
),

final as (

    select 
        application.*,
        coalesce(interview_metrics.has_interviewed_w_hiring_manager, false) as has_interviewed_w_hiring_manager,

        coalesce(interview_metrics.count_interviews, 0) as count_interviews,
        coalesce(interview_metrics.count_interview_scorecards, 0) as count_interview_scorecards,
        coalesce(interview_metrics.count_distinct_interviewers, 0) as count_distinct_interviewers,
        interview_metrics.latest_interview_scheduled_at

    from application 
    left join interview_metrics using(application_id)
)

select * from final