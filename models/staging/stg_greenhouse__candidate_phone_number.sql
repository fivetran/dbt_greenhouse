
with base as (

    select * 
    from {{ ref('stg_greenhouse__candidate_phone_number_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__candidate_phone_number_tmp')),
                staging_columns=get_candidate_phone_number_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}
    from base
),

final as (
    
    select
        source_relation,
        _fivetran_synced,
        cast(candidate_id as {{ dbt.type_string() }}) as candidate_id,
        index,
        type as phone_type,
        value as phone_number

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final