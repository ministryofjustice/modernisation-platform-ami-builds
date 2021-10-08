# Modernisation Platform AMI builds


## Introduction

This repository contains the Modernisation Platform AMI build code and workflows.

Here you can add code to build your AMIs. The process for building AMIs is still being determined. Progress can be tracked here: [#1059]


[#1059]: https://github.com/ministryofjustice/modernisation-platform/issues/1059

## How to

To add a new component or make a change to an existing component:

* Make the change to the file in the corresponding components directory
* Update the component version in the component_map variable in image_vars.tf
* Update the recipe version in the recipe block in image_vars.tf

Both the component version(s) and recipe version will need to be updated for a successful Terraform run.
No further change will need to be made to the component block of the image_builder.tf file to add / edit a component.
