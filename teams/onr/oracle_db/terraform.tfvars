# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "onr"
ami_base_name         = "oracle_db"
configuration_version = "0.0.1"
release_or_patch      = "release"
description           = "onr oracle db image"

tags = {
  description = "onr db"
  os-version  = "rhel 7.9"
  component   = "data"
  server-type = "onr-db"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "base-rhel-7-9/x.x.x"
}

block_device_mappings_ebs = [
  # {
  #   device_name = "/dev/sda1" # boot volume
  #   volume_size = 30
  #   volume_type = "gp3"
  # },
  # {
  #   device_name = "/dev/sda2" # root volume
  #   volume_size = 30
  #   volume_type = "gp3"
  # },
  # {
  #   device_name = "/dev/sdb" # /u01 oracle app disk
  #   volume_size = 128
  #   volume_type = "gp3"
  # },
  # {
  #   device_name = "/dev/sdc" # /u02 oracle app disk
  #   volume_size = 128
  #   volume_type = "gp3"
  # }
]

components_aws = [
  "update-linux"
]

components_custom = []

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["r6i.xlarge"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
  }
}

account_to_distribute_ami = "core-shared-services-production"

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test"
  ]
}

launch_template_exists = false
