with user_email as (

    select *
    from {{ ref('stg_greenhouse__user_email') }}
),

greenhouse_user as (

    select *
    from {{ ref('stg_greenhouse__user') }}
),

agg_emails as (

    select
        source_relation,
        user_id,
        {{ fivetran_utils.string_agg('email', "', '") }} as email

    from user_email

    group by 1, 2
),

final as (

    select
        greenhouse_user.*,
        agg_emails.email
    from greenhouse_user
    left join agg_emails
        on greenhouse_user.user_id = agg_emails.user_id
        and greenhouse_user.source_relation = agg_emails.source_relation
)

select * 
from final