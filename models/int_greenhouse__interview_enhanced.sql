with interview as (

    select *
    from {{ ref('int_greenhouse__interview_users') }}
),

job_stage as (

    select *
    from {{ var('job_stage') }}
),

job_info as (

    select *
    from {{ ref('int_greenhouse__job_info') }}
),

application_info

-- to determine if they've advanced since this interview
{% if var('greenhouse_using_app_history') %}
application_history as (

    select *
    from {{ var('application_history') }}
),
{% endif %}

final as (

    select
)