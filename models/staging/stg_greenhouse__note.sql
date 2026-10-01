{{ config(enabled=var('greenhouse_using_note', True)) }}

with base as (

    select *
    from {{ ref('stg_greenhouse__note_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__note_tmp')),
                staging_columns=get_note_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        cast(id as {{ dbt.type_string() }}) as activity_id,
        cast(user_id as {{ dbt.type_string() }}) as user_id,
        cast(candidate_id as {{ dbt.type_string() }}) as candidate_id,
        cast(application_id as {{ dbt.type_string() }}) as application_id,
        body,
        body_with_tags,
        cast(created_at as {{ dbt.type_timestamp() }}) as occurred_at,
        email_attachment_file_names,
        email_from,
        email_to,
        import_hash,
        subject,
        type,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        visibility

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
