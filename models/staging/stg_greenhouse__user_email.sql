
with base as (

    select *
    from {{ ref('stg_greenhouse__user_email_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__user_email_tmp')),
                staging_columns=get_user_email_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}
    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        email,
        cast(id as {{ dbt.type_string() }}) as id,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        cast(user_id as {{ dbt.type_string() }}) as user_id,
        cast(verification_token_sent_at as {{ dbt.type_timestamp() }}) as verification_token_sent_at,
        verified

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
