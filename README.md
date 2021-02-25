# Greenhouse (docs) 

This package models Greenhouse recruiting data from [Fivetran's connector](https://fivetran.com/docs/applications/greenhouse). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/greenhouse#schemainformation).

This package enables you to understand trends in sourcing,recruiting, interviewing, and hiring at your company. It

[High level objective of package]. It achieves this by:
- [major thing the package does #1]
- [ #2 ] 
- [ #3]
...

## Models 
This package contains transformation models, designed to work simultaneously with our [Greenhouse source package](https://github.com/fivetran/dbt_greenhouse_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [greenhouse__application_enhanced](models/greenhouse__application_enhanced.sql)             | Each record represents a unique application. |
| [greenhouse__application_history](models/greenhouse__application_history.sql)             | beep beep |
| [greenhouse__interview_enhanced](models/greenhouse__interview_enhanced.sql)             | beep beep |
| [greenhouse__interview_scorecard_detail](models/greenhouse__interview_scorecard_detail.sql)             | beep beep |
| [greenhouse__job_enhanced](models/greenhouse__job_enhanced.sql)             | beep beep |

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

### Passing Through Custom Columns
The Greenhouse `APPLICATION`, `JOB`, AND `CANDIDATE` tables may all have custom columns, all prefixed with `custom_field_`. To pass these columns along to the staging and final transformation models, add the following variables to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    greenhouse_application_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final application_enhanced model
    greenhouse_candidate_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final application_enhanced model
    greenhouse_job_custom_columns: ['the', 'list', 'of', 'columns'] # these columns will be in the final job_enhanced model
```

### Disabiling Models
Your Greenhouse connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Greenhouse or have actively excluded some tables from your syncs.

To disable the corresponding functionality in the package, you must add the relevant variables. By default, all variables are assumed to be true. Add variables for only the tables you would like to disable:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    greenhouse_using_prospects: false # Disable if you do not use prospects and/or do not have the PROPECT_POOL and PROSPECT_STAGE tables synced
    greenhouse_using_eeoc: false # Disable if you do not have EEOC data synced and/or do not want to integrate it into the package models
    greenhouse_using_app_history: false # Disable if you do not have APPLICATION_HISTORY synced and/or do not want to run the application_history transform model
```

## Contributions
Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `master`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Database Support
This package has been tested on BigQuery, Snowflake and Redshift.
Coming soon -- compatibility with Spark

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate dbt transformations with Fivetran [here](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
