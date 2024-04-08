# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "hmpps"
ami_base_name         = "windows_server_2019"
configuration_version = "0.0.2"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "windows server 2019"

tags = {
  os-version = "windows server 2019"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "mp-windowsserver2019/x.x.x"
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 30
    volume_type = "gp3"
  }
]

components_aws = [
  "amazon-cloudwatch-agent-windows",
  "ec2launch-v2-windows"
]

components_custom = []

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
    "oasys-national-reporting-development",
    "oasys-national-reporting-test",
    "oasys-national-reporting-preproduction",
    "oasys-national-reporting-production",
    "nomis-combined-reporting-development",
    "nomis-combined-reporting-test",
    "nomis-combined-reporting-preproduction",
    "nomis-combined-reporting-production"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "oasys-national-reporting-development",
    "oasys-national-reporting-test",
    "nomis-combined-reporting-development",
    "nomis-combined-reporting-test"
  ]

}

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "oasys-national-reporting-development",
    "oasys-national-reporting-test",
    "oasys-national-reporting-preproduction",
    "oasys-national-reporting-production",
    "nomis-combined-reporting-development",
    "nomis-combined-reporting-test",
    "nomis-combined-reporting-preproduction",
    "nomis-combined-reporting-production"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "oasys-national-reporting-development",
    "oasys-national-reporting-test",
    "nomis-combined-reporting-development",
    "nomis-combined-reporting-test"
  ]
}

launch_template_exists = false
