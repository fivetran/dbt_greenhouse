with interview as (

    select *
    from {{ ref('greenhouse__interview_enhanced') }}
),

scorecard_attribute as (

    select *
    from {{ ref('stg_greenhouse__scorecard_attribute') }}
),

join_w_attributes as (

    select
        scorecard_attribute.*,
        interview.candidate_rating,
    
        interview.candidate_name,
        interview.interviewer_name,
        interview.interview_name,
        
        interview.starts_at as interview_start_at,
        interview.scorecard_submitted_at,

        interview.application_id,
        interview.job_title,
        interview.job_id,
        {% if var('greenhouse_using_job_hiring_team', True) %}
        interview.hiring_managers,
        {% endif %}
        interview.interview_scorecard_key
        
    from interview 
    left join scorecard_attribute
        on interview.scorecard_id = scorecard_attribute.scorecard_id
        and interview.source_relation = scorecard_attribute.source_relation
),

final as (

    select 
        *,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'interview_scorecard_key', 'id']) }} as scorecard_attribute_key

    from join_w_attributes
)

select *
from final