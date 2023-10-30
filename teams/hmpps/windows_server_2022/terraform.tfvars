# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "hmpps"
ami_base_name         = "windows_server_2022"
configuration_version = "0.0.5"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "windows server 2022"

tags = {
  os-version = "windows server 2022"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "mp-windowsserver2022/x.x.x"
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
    "hmpps-domain-services-development",
    "corporate-staff-rostering-test",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-preproduction",
    "corporate-staff-rostering-production",
    "nomis-development",
    "nomis-test",
    "nomis-preproduction",
    "nomis-production",
    "oasys-development",
    "oasys-test",
    "oasys-preproduction",
    "oasys-production",
    "nomis-data-hub-development",
    "nomis-data-hub-test",
    "nomis-data-hub-preproduction",
    "nomis-data-hub-production"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "hmpps-domain-services-development",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-test",
    "nomis-development",
    "nomis-test",
    "oasys-development",
    "oasys-test",
    "nomis-data-hub-development",
    "nomis-data-hub-test"
  ]

}

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "hmpps-domain-services-development",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-test",
    "corporate-staff-rostering-preproduction",
    "corporate-staff-rostering-production",
    "nomis-development",
    "nomis-test",
    "nomis-preproduction",
    "nomis-production",
    "oasys-development",
    "oasys-test",
    "oasys-preproduction",
    "oasys-production",
    "nomis-data-hub-development",
    "nomis-data-hub-test",
    "nomis-data-hub-preproduction",
    "nomis-data-hub-production"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "hmpps-domain-services-development",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-test",
    "nomis-development",
    "nomis-test",
    "oasys-development",
    "oasys-test",
    "nomis-data-hub-development",
    "nomis-data-hub-test"
  ]
}

launch_template_exists = false
