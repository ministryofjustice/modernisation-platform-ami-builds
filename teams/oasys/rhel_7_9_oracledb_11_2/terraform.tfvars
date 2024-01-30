# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "oasys"
ami_base_name         = "rhel_7_9_oracledb_11_2"
configuration_version = "0.0.1"
release_or_patch      = "release" # or "patch"
description           = "oasys rhel 7.9 oracleDB 11.2 image"

tags = {
  os-version = "rhel 7.9"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "base-rhel-7-9/x.x.x"
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 30
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sdb" # /u01 oracle app disk
    volume_size = 100
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sdc" # /u02 oracle app disk
    volume_size = 100
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sds" # swap disk
    volume_size = 2
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sde" # oracle asm disk DATA01
    volume_size = 1
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sdj" # oracle asm disk FLASH01
    volume_size = 1
    volume_type = "gp3"
  },
]

components_aws = [
  "update-linux"
]

components_custom = []

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  schedule = {
    schedule_expression                = "cron(0 0 2 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

accounts_to_distribute_ami_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
    "oasys-preproduction",
    "oasys-production",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
  ]
}

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
    "oasys-preproduction",
    "oasys-production",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
  ]
}

launch_template_exists = false
