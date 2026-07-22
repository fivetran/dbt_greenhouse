{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

{% set columns_to_exclude = [
    'index', 'attribute_name', 'rating', 'attribute_category', 'overall_recommendation',
    'id', 'job_candidate_attribute_id', 'candidate_attribute_rating', 'candidate_rating', 'scorecard_attribute_key'
] + var('consistency_test_exclude_columns', []) %}

with prod as (
    select {{ dbt_utils.star(from=ref('greenhouse__interview_scorecard_detail'), except=columns_to_exclude) }}
    from {{ target.schema }}_greenhouse_prod.greenhouse__interview_scorecard_detail
),

dev as (
    select {{ dbt_utils.star(from=ref('greenhouse__interview_scorecard_detail'), except=columns_to_exclude) }}
    from {{ target.schema }}_greenhouse_dev.greenhouse__interview_scorecard_detail
), 

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final