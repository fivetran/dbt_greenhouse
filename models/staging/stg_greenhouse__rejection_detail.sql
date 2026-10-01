{{ config(enabled=var('greenhouse_using_rejection_detail', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__rejection_detail_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__rejection_detail_tmp')),
                staging_columns=get_rejection_detail_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as rejection_detail_id,
        cast(application_id as {{ dbt.type_string() }}) as application_id,
        cast(rejected_by_id as {{ dbt.type_string() }}) as rejected_by_id,
        cast(rejection_reason_id as {{ dbt.type_string() }}) as rejection_reason_id,
        cast(rejected_at as {{ dbt.type_timestamp() }}) as rejected_at,
        cast(rejection_note_id as {{ dbt.type_string() }}) as rejection_note_id,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
