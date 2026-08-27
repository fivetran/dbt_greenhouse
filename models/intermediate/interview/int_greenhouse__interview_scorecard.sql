{{ config(enabled=var('greenhouse_using_interview', True)) }}

with scorecard as (

    select *
    from {{ ref('stg_greenhouse__scorecard') }}
),

{% if var('greenhouse_using_interviewer', True) %}
interviewer as (

    select *
    from {{ ref('stg_greenhouse__interviewer') }}
),
{% endif %}

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
        {{ dbt.datediff('interview.starts_at', 'interview.ends_at', 'minute') }} as duration_interview_minutes

        {% if var('greenhouse_using_interviewer', True) %}
        ,
        scorecard.scorecard_id,
        scorecard.candidate_rating,
        scorecard.submitted_at as scorecard_submitted_at,
        scorecard.submitted_by_user_id as scorecard_submitted_by_user_id,
        scorecard.last_updated_at as scorecard_last_updated_at,

        interviewer.interviewer_user_id
        {% endif %}

    from interview
    {% if var('greenhouse_using_interviewer', True) %}
    left join interviewer
        on interview.scheduled_interview_id = interviewer.scheduled_interview_id
        and interview.source_relation = interviewer.source_relation
    left join scorecard
        on interviewer.scorecard_id = scorecard.scorecard_id
        and interviewer.source_relation = scorecard.source_relation
    {% endif %}
    left join job_interview_stage
        on interview.job_interview_id = job_interview_stage.job_stage_id
        and interview.source_relation = job_interview_stage.source_relation
),

-- add surrogate key for tests
final as (

    select
        *,
        {% if var('greenhouse_using_interviewer', True) %}
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'scheduled_interview_id', 'interviewer_user_id']) }} as interview_scorecard_key
        {% else %}
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'scheduled_interview_id']) }} as interview_scorecard_key
        {% endif %}

    from interview_w_scorecard
)

select *
from final