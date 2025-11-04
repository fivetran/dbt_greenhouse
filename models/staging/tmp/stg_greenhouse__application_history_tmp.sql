{{ config(enabled=var('greenhouse_using_app_history', True)) }}

{{
    greenhouse.greenhouse_union_connections(
        connection_dictionary='greenhouse_sources',
        single_source_name='greenhouse',
        single_table_name='application_history'
    )
}}