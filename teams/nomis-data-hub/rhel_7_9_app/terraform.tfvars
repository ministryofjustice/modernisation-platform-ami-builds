# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "nomis_data_hub"
ami_base_name         = "rhel_7_9_app"
configuration_version = "0.0.4"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "nomis data hub rhel 7.9 app image"

tags = {
  os-version = "rhel 7.9"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "base-rhel-7-9/x.x.x"
}

components_aws = [
  "update-linux"
]

block_device_mappings_ebs = []

components_custom = []

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  # schedule = {
  #   schedule_expression                = "cron(0 0 2 * ? *)"
  #   pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  # }
}

accounts_to_distribute_ami_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
  ]
}

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "nomis-data-hub-development",
    "nomis-data-hub-test",
    "nomis-data-hub-preproduction",
    "nomis-data-hub-production",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "nomis-data-hub-development",
    "nomis-data-hub-test",
  ]
}
