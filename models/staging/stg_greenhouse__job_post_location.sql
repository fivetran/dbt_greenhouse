{{ config(enabled=var('greenhouse_using_job_post_location', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__job_post_location_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__job_post_location_tmp')),
                staging_columns=get_job_post_location_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}
    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as job_post_location_id,
        cast(job_post_id as {{ dbt.type_string() }}) as job_post_id,
        cast(office_id as {{ dbt.type_string() }}) as office_id,
        cast(custom_location_id as {{ dbt.type_string() }}) as custom_location_id,
        plain_text_location,
        type,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at

    from fields
)

select * from final
