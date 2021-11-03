# Modernisation Platform AMI builds

## Introduction

This repository contains the Modernisation Platform AMI build code and workflows.

__Contents__

- [Modernisation Platform AMI builds](#modernisation-platform-ami-builds)
  - [Introduction](#introduction)
    - [AWS EC2 Image Builder](#aws-ec2-image-builder)
    - [Building and testing of AMIs target the core shared-services account](#building-and-testing-of-amis-target-the-core-shared-services-account)
  - [Structure](#structure)
  - [How to guides](#how-to-guides)
    - [How to add a new team](#how-to-add-a-new-team)
    - [How to define an AMI (and associated Image Builder resources)](#how-to-define-an-ami-and-associated-image-builder-resources)
    - [How to new components and manage versions](#how-to-new-components-and-manage-versions)
    - [How to add a new GitHub workflow](#how-to-add-a-new-github-workflow)
  - [Future additions and improvements](#future-additions-and-improvements)

### AWS EC2 Image Builder

Infrastructure-as-code (Terraform) is used in this repository to define AMIs and uses __AWS EC2 Image Builder__ - a managed service for building, testing and deploying Amazon Machine Images. See https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html for information.

AWS Image Builder introduces concepts such as pipelines, recipes and components to define an AMI. These concepts are backed by equivalent Terraform resources. Recipes and Components natively enforce versioning, allowing changes to be tracked and identified. This raises an interesting consideration around the declarative nature of Terraform in combination with inherent versioning within Git repositories - a consideration which has led to a recommended approach in the use of AWS Image Builder within this repository.

### Building and testing of AMIs target the core shared-services account

All Image Builder resources are deployed to, and execute within, the core shared-services account within the Modernisation Platform.
Therefore, Image Builder resources other than your own will exist in this account. However, all resources are prefixed with a team name to allow your resources to be easily identified and separated from others.

## Structure

In terms of defining AMIs, two important directories exist in this repository.

- ./*__modernisation-platform__* 
  - This directory will contain pipelines that will define AMIs acting as parent images for more customised AMIs required by Modernisation Platform consumers. Types of AMIs produced could be
    - AMIs for hardened OSs
    - AMIs for vanilla server applications, installed onto hardened OSs
- ./*__teams__*
  - This directory is designed to hold additional directories for each team that is a Modernisation Platform consumer (AKA environment or member)
  - Teams therefore define their AMIs within their own directory, referencing parent images defined and generated within the Modernisation Platform directory
  - The ```example``` directory is a template for each new team

Both of the above directories also contain a ```components``` directory, holding components relevant to Linux or Windows (within the respective OS folder)

## How to guides

### How to add a new team

To add a new team

- copy the files under the *__teams/example__* directory into e.g. *__teams/your_team__*
- change the _team_name_ variable in *__locals.tf__*, which will subsequently be interpolated and used in all Image Builder resource names.
- Each team directory will use a different terraform remote state file defined in *__backend.tf__* - so also rename the state file name by renaming the ```key``` attribute value, updating the team name to be consistent to that used in the previous step.   
```
  key = "imagebuilder-[team name].tfstate"
```

### How to define an AMI (and associated Image Builder resources)

Using the linux_pipeline.tf and linux_pipeline_vars.tf files as example files

- Replace linux_pipeline with your desired name for both files
- Update _components_ and _aws_components_ lists with the sequenced components you want included in the image (_components_ being your custom yml files under the components directory, _aws_components_ being the names of the components supplied by Amazon which are [not in this repo])
- Update any other variables you wish to change, such as cron schedule, instance size etc.


### How to new components and manage versions

To add a new component or make changes to an existing component:

* Make the change to the file in the corresponding components directory (modernisation-platform or team)
* Increment the **component** version in the parameters section of the component file
* Increment the **recipe** version in the recipe block in the pipeline vars file

Both the component version(s) and recipe version will need to be updated for a successful Terraform run.
No further change will need to be made to the component block of the pipeline terraform file to add / edit a component (there is logic to ingest the list defined in the pipeline vars and create terraform resources from them).

### How to add a new GitHub workflow

GitHub workflow files are used to invoke Terraform and an example workflow is defined at [./.github/workflows/example.yml](./.github/workflows/example.yml).
To create a workflow for your team, simply copy ```example.yml``` and add a new file named ```[your_team_name].yml```.
The workflow within the example workflow has no branch condition that might restrict when Terraform is applied. Please change as appropriate for your team's processes.

## Future additions and improvements

* Investigate and implement a design around access to S3 buckets for purposes of analysing Image Builder logs and hosting of external software packages and installers 
* Implement AMI lifecycle management (including EBS volume snapshots)
* Pipeline name could be variabilised further (e.g. with operating system)
* Investigate and consider potential to integrate Image Distribution with AWS Organisation OUs (new feature at the time of writing introduced Oct 2021)
* Consider separate environment for deploying / testing branches against
* Consider implementation of OPA tests to safeguard changes to files that should remain static

