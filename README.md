# Greenhouse ([docs](https://fivetran-dbt-greenhouse.netlify.app/#!/overview))

This package models Greenhouse recruiting data from [Fivetran's connector](https://fivetran.com/docs/applications/greenhouse). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/greenhouse#schemainformation).

This package enables you to understand trends in sourcing, recruiting, interviewing, and hiring at your company. It also provides recruiting stakeholders with information about individual applications, interviews, scorecards, and jobs.
It achieves all of this by:
- Enriching the core `APPLICATION`, `INTERVIEW`, and `JOB` tables with relevant pipeline data and metrics
- Integrating the `INTERVIEW` table with interviewer information and feedback at both the overall scorecard and individual standard levels
- Calculating the velocity and activity of applications through each pipeline stage, along with major job- and candidate-related attributes for segmented funnel analysis

## Models 
This package contains transformation models, designed to work simultaneously with our [Greenhouse source package](https://github.com/fivetran/dbt_greenhouse_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [greenhouse__application_enhanced](models/greenhouse__application_enhanced.sql)             | Each record represents a unique [application](https://developers.greenhouse.io/harvest.html#applications), enriched with data regarding the applicant's current stage, source, contact information and resume, associated tags, demographic information, recruiter, coordinator, referrer, hiring managers, and the job they are applying for. Includes metrics surrounding the candidate's interviews and their volume of activity in Greenhouse.  |
| [greenhouse__job_enhanced](models/greenhouse__job_enhanced.sql)             | Each record represents a unique [job](https://developers.greenhouse.io/harvest.html#jobs), enriched with its associated offices, teams, departments, and hiring team members. Includes metrics regarding the volume of open, rejected, and hired applications, its active and filled job openings, any job posts, and its active, archived, and converted prospects. |
| [greenhouse__interview_enhanced](models/greenhouse__interview_enhanced.sql)             | Each record represents a unique [scheduled interview](https://developers.greenhouse.io/harvest.html#scheduled-interviews) between an individual interviewer and a candidate (so a panel of three interviewers will have three records). Includes overall interview feedback, information about the users involved with this interview and application, the application's current status, and data regarding the candidate and the job being interviewed for. |
| [greenhouse__interview_scorecard_detail](models/greenhouse__interview_scorecard_detail.sql)             | Each record represents a unique scorecard attribute or an individual standard to be rated along for an interview. Includes information about the candidate, job, and interview at large. *Note: Does not include free-form text responses to scorecard questions.*|
| [greenhouse__application_history](models/greenhouse__application_history.sql)             | Each record represents an application advancing to a new stage. Includes data about the time spent in each stage, the volume of activity per stage, the application source, candidate demographics, recruiters, and hiring managers, as well as the job's team, office, and department. |


## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default, this package looks for your Greenhouse data in the `greenhouse` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Greenhouse data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    greenhouse_database: your_database_name
    greenhouse_schema: your_schema_name 
```

### Passthrough Custom Columns
The Greenhouse `APPLICATION`, `JOB`, and `CANDIDATE` tables may have custom columns, all prefixed with `custom_field_`. To pass these columns along to the staging and final transformation models, add the following variables to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    greenhouse_application_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final application_enhanced model
    greenhouse_candidate_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final application_enhanced model
    greenhouse_job_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final job_enhanced model
```

### Disabling Models
Your Greenhouse connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Greenhouse or have actively excluded some tables from your syncs.

To disable the corresponding functionality in the package, you must add the relevant variables. By default, all variables are assumed to be `true`. Add variables for only the tables you would like to disable:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    greenhouse_using_prospects: false # Disable if you do not use prospects and/or do not have the PROPECT_POOL and PROSPECT_STAGE tables synced
    greenhouse_using_eeoc: false # Disable if you do not have EEOC data synced and/or do not want to integrate it into the package models
    greenhouse_using_app_history: false # Disable if you do not have APPLICATION_HISTORY synced and/or do not want to run the application_history transform model
    greenhouse_using_job_office: false # Disable if you do not have JOB_OFFICE and/or OFFICE synced, or do not want to include offices in the job_enhanced transform model
    greenhouse_using_job_department: false # Disable if you do not have JOB_DEPARTMENT and/or DEPARTMENT synced, or do not want to include offices in the job_enhanced transform model
```

*Note: This package only integrates the above variables. If you'd like to disable other models, please create an [issue](https://github.com/fivetran/dbt_greenhouse/issues) specifying which ones.*

### Changing the Build Schema
By default this package will build the Greenhouse Source staging models within a schema titled (<target_schema> + `_stg_greenhouse`) and the Greenhouse final transform models within a schema titled (<target_schema> + `_greenhouse`) in your target database. If this is not where you would like you Greenhouse staging and final models to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    greenhouse:
        +schema: my_new_final_models_schema # leave blank for just the target_schema
    greenhouse_source:
        +schema: my_new_staging_models_schema # leave blank for just the target_schema

```

## Contributions
Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `master`. See [the Discourse post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) for information on how to contribute to a package.

## Database Support
This package has been tested on BigQuery, Snowflake and Redshift.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
