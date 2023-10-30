# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

region                = "eu-west-2"
ami_name_prefix       = "nomis"
ami_base_name         = "rhel_7_9_weblogic_xtag_10_3"
configuration_version = "0.0.4"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "nomis rhel 7.9 weblogic XTAG image"

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
    device_name = "/dev/sdb" # /u01
    volume_size = 25
    volume_type = "gp3"
  }
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
  instance_types = ["t3.large"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

launch_template_exists = false

account_to_distribute_ami = "core-shared-services-production"

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "nomis-development",
    "nomis-test",
    "nomis-preproduction",
    "nomis-production"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "nomis-development",
    "nomis-test"
  ]
}
