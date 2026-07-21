
with base as (

    select *
    from {{ ref('stg_greenhouse__attachment_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__attachment_tmp')),
                staging_columns=get_attachment_columns()
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
        cast(candidate_id as {{ dbt.type_string() }}) as candidate_id,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        filename,
        cast(id as {{ dbt.type_string() }}) as id,
        type,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        url

    from fields
)

select * from final
