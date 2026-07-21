{{
  config(
    materialized = 'table'
    )
}}

select *
from {{ ref('int_greenhouse__candidate_contacts') }}