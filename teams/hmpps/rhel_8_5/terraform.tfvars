# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "hmpps"
ami_base_name         = "rhel_8_5_join_to_azure"
configuration_version = "0.0.1"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "hmpps rhel 8.5 join to Azure domain"

tags = {
  os-version = "rhel 8.5"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "base-rhel-8-5/x.x.x"
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 30
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sdb" # /u01
    volume_size = 100
    volume_type = "gp3"
  }
]

components_aws = ["update-linux"]

components_custom = []

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

accounts_to_distribute_ami_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "hmpps-domain-services-test"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "hmpps-domain-services-test"
  ]
}

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "hmpps-domain-services-test"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "hmpps-domain-services-test"
  ]
}

launch_template_exists = false