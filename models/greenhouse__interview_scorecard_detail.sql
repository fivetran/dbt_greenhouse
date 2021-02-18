with interview as (

    select *
    from {{ ref('greenhouse__interview_enhanced') }}
),

scorecard_attribute as (

    select *
    from {{ var('scorecard_attribute') }}
),

join_w_attributes as (

    select
        scorecard_attribute.*,
        interview.overall_recommendation,
    
        interview.candidate_first_name,
        interview.candidate_last_name,
        interview.interviewer_first_name,
        interview.interviewer_last_name,
        interview.interview_name,
        
        interview.start_at as interview_start_at,
        interview.scorecard_submitted_at,

        -- should we bring in any other fields? not sure if this is too many/few...
        interview.application_id,
        interview.job_title,
        interview.job_id
        
    from interview join scorecard_attribute using(scorecard_id)
),

final as (

    select 
        *,
        {{ dbt_utils.surrogate_key(['scorecard_id', 'index']) }} as scorecard_attribute_key

    from join_w_attributes
)

select *
from join_w_attributes