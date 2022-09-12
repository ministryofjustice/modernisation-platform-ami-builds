# Nomis and Oasys Images

## Overview

Terraform for managing Nomis and OASys AMI pipelines and images.

Each image has it's own terraform state.

If you make a change to a module, or ansible, this won't automatically
trigger a pipeline run. You must increment the version number in the
relevant image directory to trigger the run.

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
```

To run pipeline manually, you can either specify "all" to run terraform
across all the images, or give a specific image directory, e.g. "imagedir1"
