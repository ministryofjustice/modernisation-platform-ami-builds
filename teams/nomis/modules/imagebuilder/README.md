# Imagebuilder Module

Module for creating imagebuilder resources:

- `image_recipe`
- `infrastructure_configuration`
- `distribution_configuration`
- `image_pipeline`

To keep things simple, one instance of each of these resources is created for
every pipeline, i.e. infrastructure and distribution configuration are not
shared across pipelines.

# Introduction

The input variables mirror the terraform resources:

- `image_recipe` map for the `aws_image_recipe` terraform resource
- `infrastructure_configuration` map for the `aws_infrastructure_configuration` terraform resource
- `distribution_configuration` map for the `aws_distribution_configuration` terraform resource
- `image_pipeline` map for the `aws_image_pipeline` terraform resource

There are some common variables shared across the resources such as:

- `team_name` - resource names are prefixed with this
- `name` - the name of the image
- `description` - description of the image
- `configuration_version` - version to use for the various resources
- `tags` - set of default tags. Some additional tags are added by the module.

The resource names are in the form `${team_name}_${name}`.
The AMI name also has an optional release (e.g. release, patch, test) tag appended along with a timestamp.

# Parent AMIs

The parent AMI can be selected either by ARN or by searching for AMIs. The ARN
approach is recommended using a 'x.x.x' version since this will use the latest
version of the parent image each time an image is created. If you search for
an AMI, the version of the AMI found at the time the terraform is run will be
used every time an image is created.

# Components

AWS and custom components can be added to the image. Use template files for
custom components. The following variables are added:

- `ami` - the name of the image `${team_name}_${name}`
- `version`
- `branch` - the value of the `branch` variable passed in

The latter can be useful if testing components from a branch.
