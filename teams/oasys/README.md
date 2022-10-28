# Nomis and Oasys Images

## Overview

Terraform for managing Nomis and OASys AMI pipelines and images.

Each image has it's own terraform state.

If you make a change to a module, or ansible, this won't automatically
trigger a pipeline run. You must increment the version number in the
relevant image directory to trigger the run. Don't forget to update
the component version when there is a change to the component as well.

You can manually plan and apply terraform prior to raising a PR. This is
not recommended if multiple people are working on the same image.

Please make sure your branch is at the head of the repo before creating
a PR.

Structure:

```
ansible/    - playbooks
modules/    - the imagebuilder module
components/ - custom components, e.g. install ansible
imagedir1/  - example image directory
imagedir2/  - example image directory
main.tf     - common terraform symbolic linked by each image dir
```

To run pipeline manually, you can either specify "all" to run terraform
across all the images, or give a specific image directory, e.g. "imagedir1"

## Making use of ASGs

Building AMI images is slow. If you are building components or
ansible code, it's quickest to test the set of commands or
ansible code on a running EC2 instance. A convenient way of doing
this is by using auto scale groups (ASG).

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
