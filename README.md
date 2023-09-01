# Modernisation Platform AMI builds

[![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Fmodernisation-platform-ami-builds&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-report/modernisation-platform-ami-builds)

## Introduction

This repository contains the Modernisation Platform AMI build code and workflows.

**Contents**

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
    - [Viewing and starting Image Builder pipelines](#how-to-view-and-start-ec2-image-builder-pipelines)
  - [Future additions and improvements](#future-additions-and-improvements)

### AWS EC2 Image Builder

Infrastructure-as-code (Terraform) is used in this repository to define AMIs and uses **AWS EC2 Image Builder** - a managed service for building, testing and deploying Amazon Machine Images. See https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html for information.

AWS Image Builder introduces concepts such as pipelines, recipes and components to define an AMI. These concepts are backed by equivalent Terraform resources. Recipes and Components natively enforce versioning, allowing changes to be tracked and identified. This raises an interesting consideration around the declarative nature of Terraform in combination with inherent versioning within Git repositories - a consideration which has led to a recommended approach in the use of AWS Image Builder within this repository.

### Building and testing of AMIs target the core-shared-services account

All Image Builder resources are deployed to, and execute within, the core-shared-services account within the Modernisation Platform.
Therefore, Image Builder resources other than your own will exist in this account. However, all resources are prefixed with a team name to allow your resources to be easily identified and separated from others.

## Structure

In terms of defining AMIs, three important directories exist in this repository.

- ./_**modernisation-platform**_
  - This directory will contain pipelines that will define AMIs acting as parent images for more customised AMIs required by Modernisation Platform consumers. Types of AMIs produced could be
    - AMIs for hardened OSs
    - AMIs for vanilla server applications, installed onto hardened OSs
- ./_**teams**_
  - This directory is designed to hold additional directories for each team that is a Modernisation Platform consumer (AKA environment or member)
  - Teams therefore define their AMIs within their own directory, referencing parent images defined and generated within the Modernisation Platform directory
  - The `example` directory is a template for each new team
- ./_**ansible**_
  - This directory will contain common ansible resources, such as ansible roles, that can be used in AMI builds.

The `modernisation-platform` and `teams` directories also contain a `components` directory, holding components relevant to Linux or Windows (within the respective OS folder)

## How to guides

### How to add a new team

To add a new team

- copy the files under the _**teams/example**_ directory into e.g. _**teams/your_team**_
- change the _team_name_ variable in _**locals.tf**_, which will subsequently be interpolated and used in all Image Builder resource names.
- Each team directory will use a different terraform remote state file defined in _**backend.tf**_ - so also rename the state file name by renaming the `key` attribute value, updating the team name to be consistent to that used in the previous step.

```
  key = "imagebuilder-[team name].tfstate"
```
**To ensure you can review any PRs you generate** add the team to the **.github/CODEOWNERS**. Check the contents of the file to see what is needed. Generally it is /teams/<team name> @ministryofjustice/<team name>. Ones that are currently in place can be seen in CODEOWNERS. 

### How to define an AMI (and associated Image Builder resources)

Using the linux_pipeline.tf and linux_pipeline_vars.tf files as example files

- Replace linux_pipeline with your desired name for both files
- Update _components_ and _aws_components_ lists with the sequenced components you want included in the image (_components_ being your custom yml files under the components directory, _aws_components_ being the names of the components supplied by Amazon which are [not in this repo])
- Update any other variables you wish to change, such as cron schedule, instance size etc.

### How to add your own team kms key

Under your team directory:

- In _**data.tf**_, edit the data block changing the _**key_id**_ to match the new key to be used in the pipeline.\
  _**default key:**_ `key_id = "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/ebs-encryption-key"`\
  _**team key:**_ `key_id = "arn:aws:kms:eu-west-2:${local.environment_management.account_ids["<team environemnt>"]}:alias/<team kms key alias name>"`\

_**example of team key:**_ `key_id = "arn:aws:kms:eu-west-2:${local.environment_management.account_ids["sprinkler-development"]}:alias/sprinkler_ebs-encryption-key"`

The requirements, as an example, for sprinkler are shown below.

Under data.tf

```
data "aws_kms_key" "sprinkler_ebs_encryption_key" {
  key_id = "arn:aws:kms:eu-west-2:${local.environment_management.account_ids["sprinkler-development"]}:alias/sprinkler_ebs-encryption-key"
}
```

At the end of locals.tf include

```
ami_share_accounts = [
  "${local.environment_management.account_ids["sprinkler-development"]}"
]
```

The above can be seen in the pull request https://github.com/ministryofjustice/modernisation-platform-ami-builds/pull/18/files/6a589a6d3d0dc70f2bc28cb8cbb84075cad9d73c# but this includes far more detail than is required here.

Example code on how to create a team KMS key, and the permissions needed can be found in https://github.com/ministryofjustice/modernisation-platform-environments/blob/b73bba2e9d708efbc0db4492582829f52f00cb60/terraform/environments/sprinkler/kms.tf

### How to use the per business unit shared kms key

There are keys created per business unit which have permissions to be used by all the member accounts in that business unit. Using these keys means you do not have to create your own key, and you can easily share your AMIs between other accounts in your business unit. A full list of the shared keys available can be found in the core-shared-services account. To be used as shown below.

`data "aws_kms_key" "ebs_encryption_cmk" {key_id = "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/ebs-<business-unit>"}`

For example:

`data "aws_kms_key" "ebs_encryption_cmk" {key_id = "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/ebs-hmpps"}`

### How to edit ami account share

This is a optional task and doesn't have to be done, this should only be changed if you want to share images with particular accounts.\
Under your team directory:

- In _**locals.tf**_ edit the _**ami_share_accounts**_ section, changing the account from the default core-shared-services to your account of choice.\
  _**default:**_ `"${local.environment_management.account_ids["core-shared-services-production"]}"`\
  _**member account:**_ `"${local.environment_management.account_ids["<member account>"]}"`\

_**example member account:**_ `"${local.environment_management.account_ids["sprinkler-development"]}"`

### How to add new components and manage versions

To add a new component or make changes to an existing component:

- Make the change to the file in the corresponding components directory (modernisation-platform or team)
- Increment the **component** version in the parameters section of the component file
- Increment the **recipe** version in the recipe block in the pipeline vars file

Both the component version(s) and recipe version will need to be updated for a successful Terraform run.
No further change will need to be made to the component block of the pipeline terraform file to add / edit a component (there is logic to ingest the list defined in the pipeline vars and create terraform resources from them).

### How to add a new GitHub workflow

GitHub workflow files are used to invoke Terraform and an example workflow is defined at [./.github/workflows/example.yml](./.github/workflows/example.yml).
To create a workflow for your team, simply copy `example.yml` and add a new file named `[your_team_name].yml`.
The workflow within the example workflow has no branch condition that might restrict when Terraform is applied. Please change as appropriate for your team's processes.

### How to view and start EC2 Image Builder pipelines

You can view and start EC2 Image Builder pipelines by assuming a role in the core-shared-services account.

- [Log in to the AWS console](https://user-guide.modernisation-platform.service.justice.gov.uk/user-guide/accessing-the-aws-console.html#accessing-the-aws-console) via SSO as a modernisation-platform-developer
- Click your SSO username in the top right of the AWS Console and choose "Switch Role"
- Enter the core-shared-services account number ([see Slack message](https://mojdt.slack.com/archives/C01A7QK5VM1/p1645178678535589))
- Enter role as `member-shared-services`
- Navigate to EC2 Image Builder and click on “Image pipelines”
- Choose your pipeline, you can view details and run the pipeline via “Actions”

## Future additions and improvements

- Investigate and implement a design around access to S3 buckets for purposes of analysing Image Builder logs and hosting of external software packages and installers
- Implement AMI lifecycle management (including EBS volume snapshots)
- Pipeline name could be variabilised further (e.g. with operating system)
- Investigate and consider potential to integrate Image Distribution with AWS Organisation OUs (new feature at the time of writing introduced Oct 2021)
- Consider separate environment for deploying / testing branches against
- Consider implementation of OPA tests to safeguard changes to files that should remain static
