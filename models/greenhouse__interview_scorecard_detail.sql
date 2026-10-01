{{ config(enabled=var('greenhouse_using_interview', True) and var('greenhouse_using_interviewer', True)) }}

with interview as (

    select *
    from {{ ref('greenhouse__interview_enhanced') }}
),

scorecard_candidate_attribute as (

    select *
    from {{ ref('stg_greenhouse__scorecard_candidate_attribute') }}
),

{% if var('greenhouse_using_job_candidate_attribute', True) %}
job_candidate_attribute as (

    select *
    from {{ ref('stg_greenhouse__job_candidate_attribute') }}
),
{% endif %}

{% if var('greenhouse_using_scorecard_question', True) %}
scorecard_question_answer as (

    select *
    from {{ ref('stg_greenhouse__scorecard_question_answer') }}
),

scorecard_question as (

    select *
    from {{ ref('stg_greenhouse__scorecard_question') }}
),
{% endif %}

join_w_attributes as (

    select
        scorecard_candidate_attribute.*,
        interview.candidate_rating,

        interview.candidate_name,
        interview.interviewer_name,
        interview.interview_name,

        interview.starts_at as interview_start_at,
        interview.scorecard_submitted_at,

        interview.application_id,
        interview.job_title,
        interview.job_id,
        {% if var('greenhouse_using_job_hiring_manager', True) %}
        interview.hiring_managers,
        {% endif %}
        interview.interview_scorecard_key

        {% if var('greenhouse_using_job_candidate_attribute', True) %}
        ,
        job_candidate_attribute.attribute_name,
        job_candidate_attribute.sort_order
        {% endif %}

        {% if var('greenhouse_using_scorecard_question', True) %}
        ,
        scorecard_question.question_text,
        scorecard_question.answer_type,
        scorecard_question_answer.answer,
        scorecard_question_answer.boolean_value
        {% endif %}

    from interview
    left join scorecard_candidate_attribute
        on interview.scorecard_id = scorecard_candidate_attribute.scorecard_id
        and interview.source_relation = scorecard_candidate_attribute.source_relation

    {% if var('greenhouse_using_job_candidate_attribute', True) %}
    left join job_candidate_attribute
        on scorecard_candidate_attribute.job_candidate_attribute_id = job_candidate_attribute.job_candidate_attribute_id
        and scorecard_candidate_attribute.source_relation = job_candidate_attribute.source_relation
    {% endif %}

    {% if var('greenhouse_using_scorecard_question', True) %}
    left join scorecard_question_answer
        on interview.scorecard_id = scorecard_question_answer.scorecard_id
        and interview.source_relation = scorecard_question_answer.source_relation
    left join scorecard_question
        on scorecard_question_answer.scorecard_question_id = scorecard_question.scorecard_question_id
        and scorecard_question_answer.source_relation = scorecard_question.source_relation
    {% endif %}
),

final as (

    select 
        *,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'interview_scorecard_key', 'id']) }} as scorecard_attribute_key

    from join_w_attributes
)

select *
from final