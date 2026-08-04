with scorecard as (

    select *
    from {{ ref('stg_greenhouse__scorecard') }}
),

interviewer as (

    select *
    from {{ ref('stg_greenhouse__interviewer') }}
),

interview as (

    select *
    from {{ ref('stg_greenhouse__interview') }}
),

job_interview_stage as (

    select *
    from {{ ref('stg_greenhouse__job_interview_stage') }}
),

interview_w_scorecard as (

    select
        interview.*,

        job_interview_stage.stage_name as interview_name,
        {{ dbt.datediff('interview.starts_at', 'interview.ends_at', 'minute') }} as duration_interview_minutes,
        scorecard.scorecard_id,
        scorecard.candidate_rating,
        scorecard.submitted_at as scorecard_submitted_at,
        scorecard.submitted_by_user_id as scorecard_submitted_by_user_id,
        scorecard.last_updated_at as scorecard_last_updated_at,

        interviewer.interviewer_user_id


    from interview
    left join interviewer
        on interview.scheduled_interview_id = interviewer.scheduled_interview_id
        and interview.source_relation = interviewer.source_relation
    left join scorecard
        on interviewer.scorecard_id = scorecard.scorecard_id
        and interviewer.source_relation = scorecard.source_relation
    left join job_interview_stage
        on interview.job_interview_id = job_interview_stage.job_stage_id
        and interview.source_relation = job_interview_stage.source_relation
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