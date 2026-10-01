{{ config(enabled=var('greenhouse_using_rejection_detail', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='greenhouse_sources',
        single_source_name='greenhouse',
        single_table_name='rejection_detail'
    )
}}