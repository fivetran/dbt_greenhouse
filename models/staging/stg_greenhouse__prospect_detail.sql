{{ config(enabled=var('greenhouse_using_prospect_detail', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__prospect_detail_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__prospect_detail_tmp')),
                staging_columns=get_prospect_detail_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as prospect_detail_id,
        cast(application_id as {{ dbt.type_string() }}) as application_id,
        cast(department_id as {{ dbt.type_string() }}) as department_id,
        cast(office_id as {{ dbt.type_string() }}) as office_id,
        cast(pool_id as {{ dbt.type_string() }}) as pool_id,
        cast(pool_stage_id as {{ dbt.type_string() }}) as pool_stage_id,
        cast(prospect_owner_id as {{ dbt.type_string() }}) as prospect_owner_id,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
