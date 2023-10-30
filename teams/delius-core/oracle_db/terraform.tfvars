# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "delius_core_ol_8_5"
ami_base_name         = "oracle_db_19c"
configuration_version = "0.0.7"
release_or_patch      = "patch" # see nomis AMI image building strategy doc
description           = "Delius Core Oracle Database Image"

tags = {
  os-version = "oracle linux 8.5"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "base-ol-8-5/x.x.x"
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 30
    volume_type = "gp3"
  }
]

components_aws = []

components_custom = []

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

account_to_distribute_ami = "core-shared-services-production"

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "delius-core-development",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "delius-core-development",
  ]
}

launch_template_exists = false
