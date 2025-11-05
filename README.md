# Greenhouse dbt Package ([Docs](https://fivetran.github.io/dbt_greenhouse/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_greenhouse/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?
- Produces modeled tables that leverage Greenhouse data from [Fivetran's connector](https://fivetran.com/docs/applications/greenhouse) in the format described by [this ERD](https://fivetran.com/docs/applications/greenhouse#schemainformation).

- Enables you to understand trends in sourcing, recruiting, interviewing, and hiring at your company. It also provides recruiting stakeholders with information about individual applications, interviews, scorecards, and jobs. It achieves this by:
    - Enriching the core `APPLICATION`, `INTERVIEW`, and `JOB` tables with relevant pipeline data and metrics
    - Integrating the `INTERVIEW` table with interviewer information and feedback at both the overall scorecard and individual standard levels
    - Calculating the velocity and activity of applications through each pipeline stage, along with major job- and candidate-related attributes for segmented funnel analysis

<!--section="greenhouse_transformation_model-->
- Generates a comprehensive data dictionary of your source and modeled Greenhouse data through the [dbt docs site](https://fivetran.github.io/dbt_greenhouse/#!/overview).
The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_greenhouse/#!/overview?g_v=1).

| **Table**                | **Description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [greenhouse__application_enhanced](https://fivetran.github.io/dbt_greenhouse/#!/model/model.greenhouse.greenhouse__application_enhanced)             | Each record represents a unique application, enriched with data regarding the applicant's current stage, source, contact information and resume, associated tags, demographic information, recruiter, coordinator, referrer, hiring managers, and the job they are applying for. Includes metrics surrounding the candidate's interviews and their volume of activity in Greenhouse.  |
| [greenhouse__job_enhanced](https://fivetran.github.io/dbt_greenhouse/#!/model/model.greenhouse.greenhouse__job_enhanced)             | Each record represents a unique job, enriched with its associated offices, teams, departments, and hiring team members. Includes metrics regarding the volume of open, rejected, and hired applications, its active and filled job openings, any job posts, and its active, archived, and converted prospects. |
| [greenhouse__interview_enhanced](https://fivetran.github.io/dbt_greenhouse/#!/model/model.greenhouse.greenhouse__interview_enhanced)             | Each record represents a unique scheduled interview between an individual interviewer and a candidate (so a panel of three interviewers will have three records). Includes overall interview feedback, information about the users involved with this interview and application, the application's current status, and data regarding the candidate and the job being interviewed for. |
| [greenhouse__interview_scorecard_detail](https://fivetran.github.io/dbt_greenhouse/#!/model/model.greenhouse.greenhouse__interview_scorecard_detail)             | Each record represents a unique scorecard attribute or an individual standard to be rated along for an interview. Includes information about the candidate, job, and interview at large. *Note: Does not include free-form text responses to scorecard questions.*|
| [greenhouse__application_history](https://fivetran.github.io/dbt_greenhouse/#!/model/model.greenhouse.greenhouse__application_history)             | Each record represents an application advancing to a new stage. Includes data about the time spent in each stage, the volume of activity per stage, the application source, candidate demographics, recruiters, and hiring managers, as well as the job's team, office, and department. |

### Materialized Models
Each Quickstart transformation job run materializes 68 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?

### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Greenhouse connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Step 2: Install the package
Include the following greenhouse package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/greenhouse
    version: [">=1.1.0", "<1.2.0"]
```

### Step 3: Define database and schema variables

#### Option A: Single connection
By default, this package runs using your [destination](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile) and the `greenhouse` schema. If this is not where your Greenhouse data is (for example, if your Greenhouse schema is named `greenhouse_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  greenhouse:
    greenhouse_database: your_database_name
    greenhouse_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple Greenhouse connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

**PLEASE NOTE:** Rows from your individual Greenhouse connections will be stored together in unified tables. Given the potentially sensitive nature of Greenhouse data, confirm that this configuration complies with your organization’s PII and data governance requirements.

To use this functionality, you will need to set the `greenhouse_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  greenhouse:
    greenhouse_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

##### Recommended: Incorporate unioned sources into DAG
> *If you are running the package through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore), the below step is necessary in order to synchronize model runs with your Greenhouse connections. Alternatively, you may choose to run the package through Fivetran [Quickstart](https://fivetran.com/docs/transformations/quickstart), which would create separate sets of models for each Greenhouse source rather than one set of unioned models.*

By default, this package defines one single-connection source, called `greenhouse`, which will be disabled if you are unioning multiple connections. This means that your DAG will not include your Greenhouse sources, though the package will run successfully.

To properly incorporate all of your Greenhouse connections into your project's DAG:
1. Define each of your sources in a `.yml` file in your project. Utilize the following template for the `source`-level configurations, and, **most importantly**, copy and paste the table and column-level definitions from the package's `src_greenhouse.yml` [file](https://github.com/fivetran/dbt_greenhouse/blob/main/models/staging/src_greenhouse.yml).

```yml
# a .yml file in your root project

version: 2

sources:
  - name: <name> # ex: Should match name in greenhouse_sources
    schema: <schema_name>
    database: <database_name>
    loader: fivetran
    config:
      loaded_at_field: _fivetran_synced
      freshness: # feel free to adjust to your liking
        warn_after: {count: 72, period: hour}
        error_after: {count: 168, period: hour}

    tables: # copy and paste from greenhouse/models/staging/src_greenhouse.yml - see https://support.atlassian.com/bitbucket-cloud/docs/yaml-anchors/ for how to use anchors to only do so once
```

> **Note**: If there are source tables you do not have (see [Step 4](https://github.com/fivetran/dbt_greenhouse?tab=readme-ov-file#step-4-disable-models-for-non-existent-sources)), you may still include them, as long as you have set the right variables to `False`.

2. Set the `has_defined_sources` variable (scoped to the `greenhouse` package) to `True`, like such:
```yml
# dbt_project.yml
vars:
  greenhouse:
    has_defined_sources: true
```

### Step 4: Disable models for non-existent sources
Your Greenhouse connection might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either do not use that functionality in Greenhouse or have actively excluded some tables from your syncs.

To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables only for the tables you want to disable:

```yml
vars:
    greenhouse_using_prospects: false # Disable if you do not use prospects and/or do not have the PROPECT_POOL and PROSPECT_STAGE tables synced
    greenhouse_using_eeoc: false # Disable if you do not have EEOC data synced and/or do not want to integrate it into the package models
    greenhouse_using_app_history: false # Disable if you do not have APPLICATION_HISTORY synced and/or do not want to run the application_history transform model
    greenhouse_using_job_office: false # Disable if you do not have JOB_OFFICE and/or OFFICE synced, or do not want to include offices in the job_enhanced transform model
    greenhouse_using_job_department: false # Disable if you do not have JOB_DEPARTMENT and/or DEPARTMENT synced, or do not want to include offices in the job_enhanced transform model
```
*Note: This package only integrates the above variables. If you'd like to disable other models, please create an [issue](https://github.com/fivetran/dbt_greenhouse/issues) specifying which ones.*

### (Optional) Step 5: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Passing Through Custom Columns
The Greenhouse `APPLICATION`, `JOB`, and `CANDIDATE` tables may have custom columns, all prefixed with `custom_field_`. To pass these columns along to the staging and final transformation models, add the following variables to your `dbt_project.yml` file:

```yml
vars:
    greenhouse_application_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final application_enhanced model
    greenhouse_candidate_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final application_enhanced model
    greenhouse_job_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final job_enhanced model
```

#### Changing the Build Schema
By default this package will build the Greenhouse staging models within a schema titled (<target_schema> + `_stg_greenhouse`) and the Greenhouse final transform models within a schema titled (<target_schema> + `_greenhouse`) in your target database. If this is not where you would like you Greenhouse staging and final models to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
models:
    greenhouse:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_greenhouse/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    greenhouse_<default_source_table_name>_identifier: your_table_name 
```
</details>

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/greenhouse/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_greenhouse/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_greenhouse/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
