
with base as (

    select * 
    from {{ ref('stg_greenhouse__job_opening_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__job_opening_tmp')),
                staging_columns=get_job_opening_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}
    from base
),

final as (
    
    select
        source_relation,
        _fivetran_synced,
        cast(application_id as {{ dbt.type_string() }}) as application_id,
        cast(close_reason_id as {{ dbt.type_string() }}) as close_reason_id,
        cast(closed_at as {{ dbt.type_timestamp() }}) as closed_at,
        cast(id as {{ dbt.type_string() }}) as job_opening_id,
        cast(job_id as {{ dbt.type_string() }}) as job_id,
        cast(opened_at as {{ dbt.type_timestamp() }}) as opened_at,
        cast(opening_id as {{ dbt.type_string() }}) as opening_text_id,
        is_open as current_status,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        sort_order,
        cast(target_start_on as date) as target_start_on

    from fields
)

select * from final
