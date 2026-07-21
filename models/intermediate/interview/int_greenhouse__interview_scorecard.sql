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

job_interview_stage as (

    select *
    from {{ ref('stg_greenhouse__job_interview_stage') }}
),

interview_w_scorecard as (

    select
        scheduled_interview.*,

        job_interview_stage.stage_name as interview_name,
        {{ dbt.datediff('scheduled_interview.starts_at', 'scheduled_interview.ends_at', 'minute') }} as duration_interview_minutes,
        scorecard.scorecard_id,
        scorecard.candidate_rating,
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
    left join job_interview_stage
        on scheduled_interview.job_interview_id = job_interview_stage.job_stage_id
        and scheduled_interview.source_relation = job_interview_stage.source_relation
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