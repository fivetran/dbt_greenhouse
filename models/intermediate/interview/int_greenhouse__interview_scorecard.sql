{{ config(enabled=var('greenhouse_using_interview', True)) }}

with
{% if var('greenhouse_using_interviewer', True) %}
scorecard as (

    select *
    from {{ ref('stg_greenhouse__scorecard') }}
),

interviewer as (

    select *
    from {{ ref('stg_greenhouse__interviewer') }}
),
{% endif %}

interview as (

    select *
    from {{ ref('stg_greenhouse__interview') }}
),

job_interview as (

    select *
    from {{ ref('stg_greenhouse__job_interview') }}
),

job_interview_stage as (

    select *
    from {{ ref('stg_greenhouse__job_interview_stage') }}
),

interview_w_scorecard as (

    select
        interview.source_relation,
        interview.scheduled_interview_id,
        interview.application_id,
        interview.job_interview_id,
        interview.job_id,
        cast(interview.location as {{ dbt.type_string() }}) as location,
        interview.organizer_user_id,
        interview.status,
        interview.created_at,
        interview.last_updated_at,
        interview.starts_at,
        interview.ends_at,
        interview.scheduled_at,
        interview.availability_received_at,
        interview.all_day_start_on,
        interview.all_day_end_on,
        cast(interview.external_event_id as {{ dbt.type_string() }}) as external_event_id,
        cast(interview.video_conferencing_url as {{ dbt.type_string() }}) as video_conferencing_url,

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
    left join job_interview
        on interview.job_interview_id = job_interview.job_interview_id
        and interview.source_relation = job_interview.source_relation
    left join job_interview_stage
        on job_interview.job_interview_stage_id = job_interview_stage.job_stage_id
        and job_interview.source_relation = job_interview_stage.source_relation
),

{% if var('greenhouse_using_interviewer', True) %}
-- scorecards that exist but have no matching row on the interviewer bridge table
-- (e.g. ad-hoc scorecards) are otherwise silently dropped by the interview -> interviewer -> scorecard
-- join above. Surface them here, keyed only on application_id (not joined back to a specific
-- interview, since we have no precise way to associate them with one).
orphaned_scorecards as (

    select
        scorecard.source_relation,
        cast(null as {{ dbt.type_string() }}) as scheduled_interview_id,
        scorecard.application_id,
        cast(null as {{ dbt.type_string() }}) as job_interview_id,
        cast(null as {{ dbt.type_string() }}) as job_id,
        cast(null as {{ dbt.type_string() }}) as location,
        cast(null as {{ dbt.type_string() }}) as organizer_user_id,
        cast(null as {{ dbt.type_string() }}) as status,
        scorecard.created_at,
        scorecard.last_updated_at,
        cast(null as {{ dbt.type_timestamp() }}) as starts_at,
        cast(null as {{ dbt.type_timestamp() }}) as ends_at,
        cast(null as {{ dbt.type_timestamp() }}) as scheduled_at,
        cast(null as {{ dbt.type_timestamp() }}) as availability_received_at,
        cast(null as date) as all_day_start_on,
        cast(null as date) as all_day_end_on,
        cast(null as {{ dbt.type_string() }}) as external_event_id,
        cast(null as {{ dbt.type_string() }}) as video_conferencing_url,

        cast(null as {{ dbt.type_string() }}) as interview_name,
        cast(null as {{ dbt.type_int() }}) as duration_interview_minutes,

        scorecard.scorecard_id,
        scorecard.candidate_rating,
        scorecard.submitted_at as scorecard_submitted_at,
        scorecard.submitted_by_user_id as scorecard_submitted_by_user_id,
        scorecard.last_updated_at as scorecard_last_updated_at,

        cast(null as {{ dbt.type_string() }}) as interviewer_user_id

    from scorecard
    left join interviewer
        on scorecard.scorecard_id = interviewer.scorecard_id
        and scorecard.source_relation = interviewer.source_relation

    where interviewer.scorecard_id is null
),
{% endif %}

unioned as (

    select *
    from interview_w_scorecard

    {% if var('greenhouse_using_interviewer', True) %}
    union all
    select *
    from orphaned_scorecards
    {% endif %}
),

-- add surrogate key for tests
final as (

    select
        *,
        {% if var('greenhouse_using_interviewer', True) %}
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'scheduled_interview_id', 'interviewer_user_id', 'scorecard_id']) }} as interview_scorecard_key
        {% else %}
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'scheduled_interview_id']) }} as interview_scorecard_key
        {% endif %}

    from unioned
)

select *
from final
