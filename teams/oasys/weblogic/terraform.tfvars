# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

region                = "eu-west-2"
ami_name_prefix       = "oasys"
ami_base_name         = "weblogic"
configuration_version = "0.0.4"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "oasys weblogic app server image"

tags = {
  os-version  = "rhel 7.9"
  server-type = "oasys-weblogic"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "base-rhel-7-9/x.x.x"
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sdb" # /u01 oracle app disk
    volume_size = 100
    volume_type = "gp3"
  },
]

components_aws = [
  "update-linux"
]

components_custom = [
]

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t2.large"]
}

image_pipeline = {
  schedule = {
    schedule_expression                = "cron(0 0 2 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

launch_template_exists = false

account_to_distribute_ami = "core-shared-services-production"

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-preproduction",
    "oasys-production",
    "oasys-test",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
  ]
}
