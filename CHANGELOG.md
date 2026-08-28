# dbt_greenhouse v1.5.0

[PR #46](https://github.com/fivetran/dbt_greenhouse/pull/46) includes the following updates:

## Schema/Data Changes
**66 total changes • 36 possible breaking changes**

Updates the package to support the [Greenhouse **Harvest API v3**](https://harvestdocs.greenhouse.io/docs/overview-and-philosophy) connector schema. All staging, intermediate, and end models reflect the v3 source table and column names.

| Data Model(s) | Change type | Old | New | Notes |
| ------------- | ----------- | --- | --- | ----- |
| `greenhouse__application_enhanced` | Columns added/removed | Removed: `applied_at`, `prospect_pool_id`, `prospect_stage_id`, `prospect_owner_user_id`, `prospect_pool`, `prospect_stage`, `prospect_owner_name`, `rejected_reason_id` | Added: `job_id`, `job_post_id`, `coordinator_id`, `recruiter_id`, `coordinator_email`, `recruiter_email`, `created_at`, `updated_at`, `agency_note_id`, `preferred_name`, `time_zone`, `can_email` | **Possible breaking change:** `applied_at` and prospect pipeline data permanently removed in v3.  |
| `greenhouse__application_enhanced`<br>`stg_greenhouse__application` | Columns renamed | `current_stage_id`, `credited_to_user_id` | `stage_id`, `referrer_id` | **Possible breaking change:** Update downstream references. |
| `greenhouse__interview_enhanced`<br>`stg_greenhouse__scorecard` | Column renamed + values changed | `overall_recommendation` | `candidate_rating` | **Possible breaking change:** Values change from `definitely_not, no, yes, strong_yes, no_decision` to `strong_no, no, yes, strong_yes, no_decision`. |
| `greenhouse__interview_enhanced` | Column removed | `candidate_id` | — |  |
| `greenhouse__interview_enhanced`<br>`stg_greenhouse__interview` | Columns renamed | `interview_id`, `start_at`, `end_at` | `job_interview_id`, `starts_at`, `ends_at` | **Possible breaking change:** Update downstream references. |
| `greenhouse__interview_enhanced`<br>`stg_greenhouse__interview` | Columns added | — | `scheduled_at`, `all_day_start_on`, `all_day_end_on`, `external_event_id`, `video_conferencing_url`, `availability_received_at` |  |
| `stg_greenhouse__interview` | Column removed | `interview_kit_content` | — | **Possible breaking change:** No longer available in the v3 source table. |
| `greenhouse__interview_scorecard_detail` | Columns removed/added | Removed: `index`, `attribute_name`, `rating`, `attribute_category`, `overall_recommendation` | Added: `id`, `job_candidate_attribute_id`, `candidate_attribute_rating`, `candidate_rating` | **Possible breaking change:** |
| `greenhouse__job_enhanced`<br>`stg_greenhouse__job` | Columns added | — | `department_id`, `opened_at`, `is_template`, `copied_from_id` |  |
| `greenhouse__interview_scorecard_detail` | Surrogate key grain change | `scorecard_attribute_key` = `interview_scorecard_key` + `index` | `scorecard_attribute_key` = `interview_scorecard_key` + `id` | **Possible breaking change:** All existing key values change. |
| `stg_greenhouse__application` | Columns added/removed | Removed: `applied_at`, `prospect_owner_user_id`, `prospect_pool_id`, `prospect_stage_id`, `rejected_reason_id` | Added: `job_id`, `coordinator_id`, `recruiter_id`, `job_post_id`, `needs_decision`, `created_at`, `updated_at` | **Possible breaking change:** `job_id` was previously only on the `job_application` bridge table; `coordinator_id`/`recruiter_id` moved from `candidate` to `application` in v3. |
| `stg_greenhouse__job_post` | Columns added/removed | Removed: `location_name` | Added: `is_active`, `is_featured`, `created_at`, `demographic_question_set_id`, `first_published_at`, `job_board_id`, `language_code`, `public_url` | **Possible breaking change:** `location_name` moved to the new `stg_greenhouse__job_post_location` model. |
| `stg_greenhouse__scorecard` | Columns added/removed | Removed: `candidate_id`, `interview` | Added: `interviewer_id`, `interview_kit_id`, `status`, `notes`, `notes_with_tags`, `private_notes`, `private_notes_with_tags`, `public_notes`, `public_notes_with_tags` |  |
| `stg_greenhouse__candidate` | Columns removed | `coordinator_id`, `recruiter_id`, `new_candidate_id` | — | **Possible breaking change:** Moved to `stg_greenhouse__application` in v3. |
| `stg_greenhouse__attachment` | Column removed | `index` | — | **Possible breaking change:** `id` is the new primary key. |
| `stg_greenhouse__job_interview_stage`<br>`stg_greenhouse__job_post_location`<br>`stg_greenhouse__candidate_tag_link` | New Staging/Tmp models | — | — | New staging models (with corresponding `_tmp` models) added to support the v3 schema. |
| `stg_greenhouse__job_application`<br>`stg_greenhouse__job_department`<br>`stg_greenhouse__tag`<br>`stg_greenhouse__hiring_team`<br>`stg_greenhouse__job_stage` | Models removed/replaced | — | — | **Possible breaking change:** `job_id`/`department_id` now live directly on their source tables; `tag_name` is denormalized onto `candidate_tag_link`; `stg_greenhouse__job_interview_stage` replaces `job_stage` and the v2 `interview` source table; `hiring_team` is split into `stg_greenhouse__job_hiring_manager` and `stg_greenhouse__job_owner`, gated respectively by the new `greenhouse_using_job_hiring_manager` and `greenhouse_using_job_owner` vars (replacing the single `greenhouse_using_job_hiring_team` var). These vars are also referenced by `greenhouse__application_enhanced`, `greenhouse__interview_enhanced`, `greenhouse__interview_scorecard_detail`, and `greenhouse__application_history`. |
| `stg_greenhouse__opening`<br>`stg_greenhouse__candidate_phone_number`<br>`stg_greenhouse__prospect_pool_stage`<br>`stg_greenhouse__interview`<br>`stg_greenhouse__interviewer`<br>`stg_greenhouse__scorecard_candidate_attribute`<br>`stg_greenhouse__candidate_social_media_address`<br>`stg_greenhouse__users`<br>`stg_greenhouse__candidate_email_address` | Models renamed | `stg_greenhouse__job_opening`<br>`stg_greenhouse__phone_number`<br>`stg_greenhouse__prospect_stage`<br>`stg_greenhouse__scheduled_interview`<br>`stg_greenhouse__scheduled_interviewer`<br>`stg_greenhouse__scorecard_attribute`<br>`stg_greenhouse__social_media_address`<br>`stg_greenhouse__user`<br>`stg_greenhouse__email_address` | `stg_greenhouse__opening`<br>`stg_greenhouse__candidate_phone_number`<br>`stg_greenhouse__prospect_pool_stage`<br>`stg_greenhouse__interview`<br>`stg_greenhouse__interviewer`<br>`stg_greenhouse__scorecard_candidate_attribute`<br>`stg_greenhouse__candidate_social_media_address`<br>`stg_greenhouse__users`<br>`stg_greenhouse__candidate_email_address` | **Possible breaking change:** Renamed to match their v3 source table names. Update any direct references. |

## Feature Update
- Adds the `greenhouse_using_interview` and `greenhouse_using_interviewer` variables (defaults to `true`) which can disable the `greenhouse__interview_enhanced` and/or `greenhouse__interview_scorecard_detail` models when the `interview` and/or `interviewer` tables aren't synced. See the [README](https://github.com/fivetran/dbt_greenhouse/blob/main/README.md#disable-models-for-non-existent-sources) for more details.

## Under the Hood
- Updates all source identifier variables and integration test seed files to reflect v3 source table names. 

# dbt_greenhouse v1.4.1

[PR #47](https://github.com/fivetran/dbt_greenhouse/pull/47) includes the following updates:

## Feature Updates
- Adds DuckDB as a supported destination.


# dbt_greenhouse v1.4.0

[PR #44](https://github.com/fivetran/dbt_greenhouse/pull/44) includes the following updates:

## Under the Hood
- Migrates the `union_connections`, `apply_source_relation`, and `partition_by_source_relation` macros to the `dbt_fivetran_utils` package.
- Adds the `fivetran_using_source_casing` variable for case-sensitive destination support. When enabled, downstream transformations respect source casing to ensure consistent results. See the [Additional Configurations](https://github.com/fivetran/dbt_greenhouse/#source-casing-for-case-sensitive-destinations) section of the README for details.

# dbt_greenhouse v1.3.0

[PR #41](https://github.com/fivetran/dbt_greenhouse/pull/41) includes the following updates:

## Documentation
- Updates README with standardized Fivetran formatting.

## Under the Hood
- In the `quickstart.yml` file:
  - Adds `table_variables` for relevant sources to prevent missing sources from blocking downstream Quickstart models.
  - Adds `supported_vars` for Quickstart UI customization.

# dbt_greenhouse v1.2.0

[PR #39](https://github.com/fivetran/dbt_greenhouse/pull/39) includes the following updates:

## Features
  - Increases the required dbt version upper limit to v3.0.0

# dbt_greenhouse v1.1.0

## Schema/Data Change
**4 total changes • 3 possible breaking changes**

| Data Model(s) | Change type | Old | New | Notes |
| ------------- | ----------- | ----| --- | ----- |
| All models | New column | | `source_relation` | Identifies the source connection when using multiple Greenhouse connections |
| `greenhouse__application_enhanced` | Updated surrogate key | `application_job_key` = `application_id` + `job_id` | `application_job_key` = `source_relation` + `application_id` + `job_id` |  |
| `greenhouse__interview_enhanced`<br>`greenhouse__interview_scorecard_detail` | Updated surrogate key | `interview_scorecard_key` = `scheduled_interview_id` + `interviewer_user_id` | `interview_scorecard_key` = `source_relation` + `scheduled_interview_id` + `interviewer_user_id` |  |
| `greenhouse__interview_scorecard_detail` | Updated surrogate key | `scorecard_attribute_key` = `interview_scorecard_key` + `index` | `scorecard_attribute_key` = `source_relation` + `interview_scorecard_key` + `index` |  |

## Feature Update
- **Union Data Functionality**: This release supports running the package on multiple Greenhouse source connections. See the [README](https://github.com/fivetran/dbt_greenhouse/tree/main?tab=readme-ov-file#step-3-define-database-and-schema-variables) for details on how to leverage this feature.

**PLEASE NOTE:** Rows from your individual Greenhouse connections will be stored together in unified tables. Given the potentially sensitive nature of Greenhouse data, confirm that this configuration complies with your organization's PII and data governance requirements.

## Tests Update
- Removes uniqueness tests on non-surrogate keys. The new unioning feature requires combination-of-column tests to consider the new `source_relation` column in addition to the existing primary key, but this is not supported across dbt versions.
- These tests will be reintroduced once a version-agnostic solution is available.

# dbt_greenhouse v1.0.1

## Bug Fixes
- Updated `dbt_project.yml` variables with the new `tags` and `users` source tables, which are the new versions of the `tag` and `user` source tables. These sources were previously included, but were accidentally dropped in the Source Package consolidation release.

## Under the Hood
- Added `tags` and `users` seed files.

# dbt_greenhouse v1.0.0

[PR #35](https://github.com/fivetran/dbt_greenhouse/pull/35) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/greenhouse_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/greenhouse_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/greenhouse_source` package will also need to be removed or updated to reference this package.
  - Update any greenhouse_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_greenhouse/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Removed all `accepted_values` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_greenhouse.yml`.

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

# dbt_greenhouse v0.9.0

[PR #31](https://github.com/fivetran/dbt_greenhouse/pull/31) includes the following updates:

## Breaking Change for dbt Core < 1.9.6

> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core ([Greenhouse Source v0.9.0](https://github.com/fivetran/dbt_greenhouse_source/releases/tag/v0.9.0)). This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `greenhouse` in file
`models/src_greenhouse.yml`. The `freshness` top-level property should be moved
into the `config` of `greenhouse`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Greenhouse freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `greenhouse` package. Pin your dependency on v0.8.0 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `greenhouse` source and apply freshness via the previous release top-level property route. This will require you to copy and paste the entirety of the previous release `src_greenhouse.yml` file and add an `overrides: greenhouse_source` property.

## Documentation
- Added Quickstart model counts to README. ([#29](https://github.com/fivetran/dbt_greenhouse/pull/29))
- Corrected references to connectors and connections in the README. ([#29](https://github.com/fivetran/dbt_greenhouse/pull/29))

## Under the Hood
- Updates to ensure integration tests use latest version of dbt.

# dbt_greenhouse v0.8.0
[PR #28](https://github.com/fivetran/dbt_greenhouse/pull/28) is a breaking change due to [upstream updates](
https://github.com/fivetran/dbt_greenhouse_source/releases/tag/v0.8.0):

## Breaking Changes
- Updated `*_id` fields in upstream `stg_*` models to be cast as strings to ensure compatibility in downstream joins by avoiding potential type mismatches.
  - Note: most IDs were previously stored as integers, so `*_id` fields in the end models will now also be strings.

## Documentation
- Added dbt documentation definitions.
- Update README formatting.

## Under the Hood
- Added an additional integration test to verify functionality when `greenhouse_using_*` variables are disabled.

# dbt_greenhouse v0.7.0
[PR #25](https://github.com/fivetran/dbt_greenhouse/pull/25) is a breaking change due to [upstream updates](
https://github.com/fivetran/dbt_greenhouse_source/blob/main/CHANGELOG.md#dbt_greenhouse_source-v070):

## Upstream Changes
- Updated the logic for `stg_greenhouse__tag` and `stg_greenhouse__user` to account for the presence of the singularly or plurally-named titular source tables, tag(s) and user(s).
  - The source table `tag` was renamed to `tags` for [connectors created on or after July 18, 2024](https://fivetran.com/docs/connectors/applications/greenhouse/changelog#july2024) and the table `user` was renamed to `users` in [October 2024](https://fivetran.com/docs/connectors/applications/greenhouse/changelog#october2024).
- This is a breaking change for customers with the plurally-named tables, as they have not been able to run the models previously.

- For more information, refer to the upstream [CHANGELOG.](https://github.com/fivetran/dbt_greenhouse_source/blob/main/CHANGELOG.md#dbt_greenhouse_source-v070)

## Under the Hood
- Added validation tests under the `integration_tests/tests` folder.

# dbt_greenhouse v0.6.0
## 🎉 Feature Update 🎉
- Databricks and PostgreSQL compatibility! ([#19](https://github.com/fivetran/dbt_greenhouse/pull/19))

## 🚘 Under the Hood 🚘
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#17](https://github.com/fivetran/dbt_greenhouse/pull/17))
- Updated the pull request [templates](/.github). ([#17](https://github.com/fivetran/dbt_greenhouse/pull/17))

# dbt_greenhouse v0.5.0
[PR #13](https://github.com/fivetran/dbt_greenhouse/pull/13) includes the following breaking changes:
## 🚨 Breaking Changes 🚨:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `dbt_utils.surrogate_key` has also been updated to `dbt_utils.generate_surrogate_key`. Since the method for creating surrogate keys differ, we suggest all users do a `full-refresh` for the most accurate data. For more information, please refer to dbt-utils [release notes](https://github.com/dbt-labs/dbt-utils/releases) for this update.
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
## 🎉 Documentation and Feature Updates 🎉:
- Updated README documentation for easier navigation and dbt package setup.

# dbt_greenhouse v0.4.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_greenhouse_source`. Additionally, the latest `dbt_greenhouse_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_greenhouse v0.1.0 -> v0.3.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!