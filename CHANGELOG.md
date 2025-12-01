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

**PLEASE NOTE:** Rows from your individual Greenhouse connections will be stored together in unified tables. Given the potentially sensitive nature of Greenhouse data, confirm that this configuration complies with your organization’s PII and data governance requirements.

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
