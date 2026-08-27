with application as (

    select *
    from {{ ref('int_greenhouse__application_info') }}
),

{% if var('greenhouse_using_interview', True) %}
interview_metrics as (

    select
        source_relation,
        application_id,
        {% if var('greenhouse_using_job_hiring_manager', True) %}
        max(case when interviewer_is_hiring_manager then 1 else 0 end) as has_interviewed_w_hiring_manager,
        {% endif %}
        count(distinct scheduled_interview_id) as count_interviews,
        count(distinct scorecard_id) as count_interview_scorecards,
        count(distinct interviewer_user_id) as count_distinct_interviewers,
        max(starts_at) as latest_interview_scheduled_at

    from {{ ref('greenhouse__interview_enhanced') }}

    group by 1, 2
),
{% endif %}

final as (

    select
        application.*
        {% if var('greenhouse_using_interview', True) %}
        ,
        {% if var('greenhouse_using_job_hiring_manager', True) %}
        coalesce(interview_metrics.has_interviewed_w_hiring_manager, 0) = 1 as has_interviewed_w_hiring_manager,
        {% endif %}
        coalesce(interview_metrics.count_interviews, 0) as count_interviews,
        coalesce(interview_metrics.count_interview_scorecards, 0) as count_interview_scorecards,
        coalesce(interview_metrics.count_distinct_interviewers, 0) as count_distinct_interviewers,
        interview_metrics.latest_interview_scheduled_at
        {% endif %}

    from application
    {% if var('greenhouse_using_interview', True) %}
    left join interview_metrics
        on application.application_id = interview_metrics.application_id
        and application.source_relation = interview_metrics.source_relation
    {% endif %}
)

select * from final