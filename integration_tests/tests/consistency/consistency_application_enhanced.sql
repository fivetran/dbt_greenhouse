{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

{% set columns_to_exclude = [
    'candidate_tags', 'email',
    'applied_at', 'prospect_pool_id', 'prospect_stage_id', 'prospect_owner_user_id', 'prospect_pool', 'prospect_stage', 'prospect_owner_name', 'rejected_reason_id', 'credited_to_user_id',
    'job_id', 'coordinator_id', 'recruiter_id', 'coordinator_email', 'recruiter_email', 'created_at', 'updated_at', 'referrer_id', 'stage_id', 'job_post_id',
    'agency_note_id', 'needs_decision', 'can_email', 'preferred_name', 'time_zone',
    'custom_what_is_your_preferred_pronoun_', 'custom_how_did_you_hear_about_fivetran_'
] + var('consistency_test_exclude_columns', []) %}

with prod as (
    select {{ dbt_utils.star(from=ref('greenhouse__application_enhanced'), except=columns_to_exclude) }}
    from {{ target.schema }}_greenhouse_prod.greenhouse__application_enhanced
),

dev as (
    select {{ dbt_utils.star(from=ref('greenhouse__application_enhanced'), except=columns_to_exclude) }}
    from {{ target.schema }}_greenhouse_dev.greenhouse__application_enhanced
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