with user_email as (

    select *
    from {{ var('user_email' )}}
),

greenhouse_user as (

    select *
    from {{ var('user') }}
),

agg_emails as (

    select
        user_id,
        {{ fivetran_utils.string_agg('email', "', '") }} as emails 

    from user_email 

    group by 1
),

final as (

    select 
        greenhouse_user.*,
        agg_emails.emails
    from 
    greenhouse_user left join agg_emails using(user_id)
)

select * 
from final