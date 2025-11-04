with scorecard as (

    select *
    from {{ ref('stg_greenhouse__scorecard') }}
),

scheduled_interviewer as (

    select *
    from {{ ref('stg_greenhouse__scheduled_interviewer') }}
),

scheduled_interview as (

    select *
    from {{ ref('stg_greenhouse__scheduled_interview') }}
),

interview as (
    
    select *
    from {{ ref('stg_greenhouse__interview') }}
),

interview_w_scorecard as (

    select
        scheduled_interview.*,

        interview.job_stage_id,
        coalesce(interview.name, scorecard.interview_name) as interview_name,
        {{ dbt.datediff('scheduled_interview.start_at', 'scheduled_interview.end_at', 'minute') }} as duration_interview_minutes,
        scorecard.scorecard_id,
        scorecard.candidate_id,
        scorecard.overall_recommendation,
        scorecard.submitted_at as scorecard_submitted_at,
        scorecard.submitted_by_user_id as scorecard_submitted_by_user_id,
        scorecard.last_updated_at as scorecard_last_updated_at,

        scheduled_interviewer.interviewer_user_id
        

    from scheduled_interview
    left join scheduled_interviewer
        on scheduled_interview.scheduled_interview_id = scheduled_interviewer.scheduled_interview_id
        and scheduled_interview.source_relation = scheduled_interviewer.source_relation
    left join scorecard
        on scheduled_interviewer.scorecard_id = scorecard.scorecard_id
        and scheduled_interviewer.source_relation = scorecard.source_relation
    left join interview
        on scheduled_interview.interview_id = interview.interview_id
        and scheduled_interview.source_relation = interview.source_relation
),

-- add surrogate key for tests
final as (

    select
        *,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'scheduled_interview_id', 'interviewer_user_id']) }} as interview_scorecard_key
    
    from interview_w_scorecard
)

select *
from final