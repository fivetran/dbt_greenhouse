
with base as (

    select *
    from {{ ref('stg_greenhouse__job_post_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_greenhouse__job_post_tmp')),
                staging_columns=get_job_post_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='greenhouse') }}
    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        active as is_active,
        content,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        case when not internal then true else false end as is_external,
        cast(demographic_question_set_id as {{ dbt.type_string() }}) as demographic_question_set_id,
        featured as is_featured,
        cast(first_published_at as {{ dbt.type_timestamp() }}) as first_published_at,
        cast(id as {{ dbt.type_string() }}) as job_post_id,
        internal as is_internal,
        internal_content,
        cast(job_board_id as {{ dbt.type_string() }}) as job_board_id,
        cast(job_id as {{ dbt.type_string() }}) as job_id,
        language_code,
        live as is_live,
        public_url,
        title,
        cast(updated_at as {{ dbt.type_timestamp() }}) as last_updated_at

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final
