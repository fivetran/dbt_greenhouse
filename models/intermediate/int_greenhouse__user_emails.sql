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
        user_id,
        {{ fivetran_utils.string_agg('email', "', '") }} as email

    from user_email 

    group by 1
),

final as (

    select 
        greenhouse_user.*,
        agg_emails.email
    from 
    greenhouse_user left join agg_emails using(user_id)
)

select * 
from final