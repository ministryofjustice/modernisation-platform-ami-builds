# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "nomis"
ami_base_name         = "windows_server_2019_jumpserver"
configuration_version = "0.0.5"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "Windows Server 2019 jumpserver"

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

components_custom = [
  {
    path       = "./components/windows_server_2019_jumpserver/jumpserver_2019.yml"
    parameters = []
  }
]

infrastructure_configuration = {
  instance_types = ["t3.medium"]
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
    "nomis-development",
    "nomis-test",
    "nomis-preproduction",
    "nomis-production",
    "oasys-development",
    "oasys-test",
    "oasys-preproduction",
    "oasys-production"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "nomis-development",
    "nomis-test",
    "oasys-development",
    "oasys-test"
  ]
}

launch_template_exists = false
