# Modernisation Platform AMI builds


## Introduction

This repository contains the Modernisation Platform AMI build code and workflows.

Here you can add code to build your AMIs. The process for building AMIs is still being determined. Progress can be tracked here: [#1059]


[#1059]: https://github.com/ministryofjustice/modernisation-platform/issues/1059

## Structure

There is a *__modernisation-platform__* directory and a *__teams__* directory.

The *__modernisation-platform__* directory will contain pipelines that will create parent images. These will be Amazon base images + AWS components + any custom modernisation platform components (e.g. for adding enhanced security). Pipelines in the team directories will then be able to reference these parent images and add their own components relevant to their applications.

Custom components can be added to either the modernisation-platform or team pipelines under the *__components__* directory.

N.B. updating a custom component will require incrementing both the component version (in the component file itself) and the pipeline recipe version (specified in the pipeline vars file).
Components are in separate directories dependent on their OS.

## How to

### Adding a new team

To quickly add a new team, you can copy the files under the *__teams/example__* directory into e.g. *__teams/your_team__*
You will then need to change the _team_name_ variable in *__locals.tf__*, which will subsequently be used for prepending all pipeline resource names.

Each team directory will use a different terraform remote state file defined in *__backend.tf__* - rename the state file:
```
key = "imagebuilder-[team name].tfstate"
```
(as the _team_name_ variable cannot be used here)

Using the linux_pipeline.tf and linux_pipeline_vars.tf files as examples:

* Replace linux_pipeline with your desired name for both files
* Update _components_ and _aws_components_ lists with the components you want included in the image (_components_ being your custom yml files under the components directory, _aws_components_ being the names of the components supplied by Amazon which are not in the repo)
* Update any other variables you wish to change, such as cron schedule, instance size etc.



### Components
To add a new component or make a change to an existing component:

* Make the change to the file in the corresponding components directory (modernisation-platform or team)
* Increment the component version in the parameters section of the component file
* Update the recipe version in the recipe block in the pipeline vars file

Both the component version(s) and recipe version will need to be updated for a successful Terraform run.
No further change will need to be made to the component block of the pipeline terraform file to add / edit a component (there is logic to ingest the list defined in the pipeline vars and create terraform resources from them).


## Future improvements
* Pipeline name could be variabilised further (e.g. with operating system)
* Separate environment for deploying / testing branches against
