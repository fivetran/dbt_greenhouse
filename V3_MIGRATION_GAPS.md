# Harvest v3 Migration — Known Gaps

Reference notes on data/functionality that could not be carried forward 1:1 from the v2 (Harvest API v2) package to this v3 migration (`schema-update/v3_api`). Not for end-user docs — internal reference for follow-up discussion after this PR merges.

## Prospect pool / stage no longer joinable to applications

- **What changed:** In v2, `application.prospect_pool_id` and `application.prospect_stage_id` linked an application directly to its `prospect_pool` / `prospect_stage` (now `prospect_pool_stage`) records. Confirmed against `models/staging/src_greenhouse.yml` — the v3 `application` table has no equivalent FK columns, and no other synced table (`candidate`, etc.) carries one either.
- **Impact:** `int_greenhouse__application_info.sql` no longer joins to `prospect_pool`/`prospect_pool_stage`. `greenhouse__application_enhanced` loses the `prospect_pool` and `prospect_stage` columns entirely (already flagged as a breaking change in `CHANGELOG.md`).
- **What's still available:** `prospect_pool` and `prospect_pool_stage` remain synced source tables and are still staged (`stg_greenhouse__prospect_pool`, `stg_greenhouse__prospect_pool_stage`) for users who want to query them directly — they just don't flow into any intermediate/end model anymore.
- **Follow-up to consider:** confirm with Greenhouse/Fivetran connector team whether this FK removal is permanent in the v3 API or whether a future connector update could reintroduce a link (e.g. via a new bridge table).

## New tables staged but not wired into any downstream model

- **`candidate_tag`** (renamed/restructured from v2 `tag`/`tags`): staged as `stg_greenhouse__candidate_tag`, but `int_greenhouse__candidate_tags` now reads `tag_name` directly off the denormalized `candidate_tag_link` table, so the join to this dimension is no longer needed. No downstream consumer.
- **`rejection_reason`** (new in v3): staged as `stg_greenhouse__rejection_reason`, but `application.rejected_reason_id` was removed in v3, so there's no FK anywhere in the package to join it against. No downstream consumer.
- Both are candidates for the `_fivetran_quickstart_*` classification in `.quickstart/quickstart.yml` (nonessential/supplementary, same tier as `candidate_tag_link`, `phone_number`, `social_media_address`) — not yet added.
