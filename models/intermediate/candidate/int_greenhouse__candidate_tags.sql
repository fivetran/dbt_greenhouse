with candidate_tag as (

    select *
    from {{ ref('stg_greenhouse__candidate_tag') }}

),

agg_tags as (

    select
        source_relation,
        candidate_id,
        {{ fivetran_utils.string_agg('tag_name', "', '") }} as tags

    from candidate_tag

    group by 1, 2

)

select *
from agg_tags