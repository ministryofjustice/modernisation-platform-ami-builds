# Delius-iaps images

## Overview

Terraform for managing Delius IAPS AMI pipelines and images.

Each image has it's own terraform state.

If you make a change to a module, or ansible, this won't automatically
trigger a pipeline run. You must increment the version number in the
relevant image directory to trigger the run. Don't forget to update
the component version when there is a change to the component as well.

You can manually plan and apply terraform prior to raising a PR. This is
not recommended if multiple people are working on the same image. If
you do create an image from a branched pipeline, then `_test` will be
appended to the AMI name.

Please make sure your branch is at the head of the repo before creating
a PR.

Structure:

```
modules/    - the imagebuilder module
components/ - image specific custom components
imagedir1/  - example image directory
imagedir2/  - example image directory
main.tf     - common terraform symbolic linked by each image dir
```

To run pipeline manually, you can either specify "all" to run terraform
across all the images, or give a specific image directory, e.g. "imagedir1"

## Distribution of Images

The common terraform allows different distribution configs to be defined
depending on the branch worked on. For example, if you are developing
a new image in a branch, you can define this just to be distributed to a
development environment. Once the code is merged into main, you can then
distribute to other environments.

This is controlled by the `distribution_configuration_by_branch` variable.
This is a map where the key is the name of the branch, e.g. main, release.
The `default` key is used if the plan is run locally, or the name of the
branch isn't defined in the map.

The value corresponds to the `distribution_configuration` defined in
the imagebuilder module.

## Making use of ASGs

Building AMI images is slow. If you are building components or
ansible code, it's quickest to test the set of commands or
ansible code on a running EC2 instance. A convenient way of doing
this is by using auto scale groups (ASG).

In the relevant development environment, e.g. `nomis-development`,
ensure there is an ASG group defined for each base image. In the
`distribution_configuration` for the base image, ensure there is
a `launch_template_configuration` corresponding to that ASG and
the image `ami_distribution_configuration.target_account_ids_or_names`
contains the development account name, e.g. `nomis-development`.

When a new base image is built, it will be available to use by the ASG
in the development environment. Refreshing the EC2 instance, e.g. by
scaling down and up, will create a new EC2 instance using the new AMI

# Developer Workflow

Tips:

- format code before submitting PR, e.g. use format.sh script
- avoid multiple people working on the same image
- pre-test ansible/scripts on the relevant parent image
- create a branch, update version numbers, commit and push your changes
- use/setup ASGs to help quickly test your changes in the development account
- manually run the `nomis` pipeline. First plan, and then apply.
- manually trigger a build of the image
- test the image using the ASG
- when fully tested, increment version number again and create a PR
- once PR merged, manually run the pipeline. The image will then be available in the configured environments
