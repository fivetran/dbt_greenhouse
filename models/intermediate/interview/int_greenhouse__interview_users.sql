with interview as (

    select *
    from {{ ref('int_greenhouse__interview_scorecard') }}
),

greenhouse_user as (

    select *
    from {{ ref('int_greenhouse__user_emails') }}
),

-- necessary users = interviewer_user_id, scorecard_submitted_by_user_id, organizer_user_id
grab_user_names as (

    select
        interview.*,
        interviewer.first_name as interviewer_first_name,
        interviewer.last_name as interviewer_last_name,
        scorecard_submitter.first_name as scorecard_submitter_first_name,
        scorecard_submitter.last_name as scorecard_submitter_last_name,
        organizer.first_name as organizer_first_name,
        organizer.last_name as organizer_last_name,
        interviewer.emails as interviewer_email

    from interview

    left join greenhouse_user as interviewer
        on interview.interviewer_user_id = interviewer.user_id
    left join greenhouse_user as scorecard_submitter
        on interview.scorecard_submitted_by_user_id = scorecard_submitter.user_id 
    left join greenhouse_user as organizer
        on interview.organizer_user_id = organizer.user_id 

)

select * from grab_user_names