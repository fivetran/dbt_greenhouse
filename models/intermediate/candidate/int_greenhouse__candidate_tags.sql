with greeenhouse_tag as (

    select *
    from {{ var('tag') }}
),

candidate_tag as (

    select *
    from {{ var('candidate_tag' )}}
),

agg_tags as (

    select
        candidate_tag.candidate_id,
        {{ fivetran_utils.string_agg('greeenhouse_tag.tag_name', "', '") }} as tags 

    from candidate_tag 
    join greeenhouse_tag using(tag_id)

    group by 1
)

select * 
from agg_tags