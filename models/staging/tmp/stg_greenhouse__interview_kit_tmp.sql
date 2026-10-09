{{ config(enabled=var('greenhouse_using_interview', True) and var('greenhouse_using_interview_kit', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='greenhouse_sources',
        single_source_name='greenhouse',
        single_table_name='interview_kit'
    )
}}