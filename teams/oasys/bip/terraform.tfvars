# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "oasys"
ami_base_name         = "bip"
configuration_version = "0.0.1"
release_or_patch      = "release"
description           = "oasys bip image"

tags = {
  os-version  = "rhel 7.9"
  server-type = "oasys-bip"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "base-rhel-7-9/x.x.x"
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # boot volume
    volume_size = 30
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sda2" # root volume
    volume_size = 30
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sdb" # /u01 oracle app disk
    volume_size = 128
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sdc" # /u02 oracle app disk
    volume_size = 128
    volume_type = "gp3"
  }
]

components_aws = [
  "update-linux"
]

components_custom = []

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t3.large"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

# need to distribute to all oasys accounts if making instance
# if making asg you only need to build the ami in core-shared-services-production
# this is because otherwise (for some reason) when making an instance it won't be able to find the disk snapshots - probably a permission issue
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

launch_template_exists = false
