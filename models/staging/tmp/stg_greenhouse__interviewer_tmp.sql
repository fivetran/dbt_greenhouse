{{ config(enabled=var('greenhouse_using_interviewer', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='greenhouse_sources',
        single_source_name='greenhouse',
        single_table_name='interviewer'
    )
}}
