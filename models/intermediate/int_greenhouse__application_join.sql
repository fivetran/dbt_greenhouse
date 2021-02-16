with candidate as (

    select *
    from {{ ref('int_greenhouse__candidate_users') }}
),


-- todo: add enabled var
eeoc as (

    select *
    from {{ var('eeoc') }}
),

job_stage as (

    select *,
    from {{ var('job_stage') }}
),

source as (

    selct *
    from {{ var('source') }}
),

activity as (

    select 
        candidate_id,

    from {{ var('activity') }}
)

select null

-- prospect pool stuff
-- job stuff
-- compute metrics someplace
-- interviews
-- pronouns