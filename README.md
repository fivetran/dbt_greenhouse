# Greenhouse Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_greenhouse/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_greenhouse/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?
- Produces modeled tables that leverage Greenhouse data from [Fivetran's connector](https://fivetran.com/docs/applications/greenhouse) in the format described by [this ERD](https://fivetran.com/docs/applications/greenhouse#schemainformation) and builds off the output of our [Greenhouse source package](https://github.com/fivetran/dbt_greenhouse_source).

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
    version: [">=0.8.0", "<0.9.0"]
```

### Step 3: Define database and schema variables
By default, this package runs using your destination and the `greenhouse` schema. If this is not where your Greenhouse data is (for example, if your Greenhouse schema is named `greenhouse_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    greenhouse_database: your_database_name
    greenhouse_schema: your_schema_name 
```

### Step 4: Disable models for non-existent sources
Your Greenhouse connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either do not use that functionality in Greenhouse or have actively excluded some tables from your syncs.

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

<details><summary>Expand for configurations</summary>

#### Passing Through Custom Columns
The Greenhouse `APPLICATION`, `JOB`, and `CANDIDATE` tables may have custom columns, all prefixed with `custom_field_`. To pass these columns along to the staging and final transformation models, add the following variables to your `dbt_project.yml` file:

```yml
vars:
    greenhouse_application_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final application_enhanced model
    greenhouse_candidate_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final application_enhanced model
    greenhouse_job_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final job_enhanced model
```

#### Changing the Build Schema
By default this package will build the Greenhouse Source staging models within a schema titled (<target_schema> + `_stg_greenhouse`) and the Greenhouse final transform models within a schema titled (<target_schema> + `_greenhouse`) in your target database. If this is not where you would like you Greenhouse staging and final models to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
models:
    greenhouse:
        +schema: my_new_final_models_schema # leave blank for just the target_schema
    greenhouse_source:
        +schema: my_new_staging_models_schema # leave blank for just the target_schema

```
#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_greenhouse_source/blob/main/dbt_project.yml) variable declarations to see the expected names.

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

    - package: fivetran/greenhouse_source
      version: [">=0.8.0", "<0.9.0"]
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
