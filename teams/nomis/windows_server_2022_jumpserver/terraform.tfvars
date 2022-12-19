# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "nomis"
ami_base_name         = "windows_server_2022_jumpserver"
configuration_version = "0.3.0"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "Windows Server 2022 jumpserver"

tags = {
  os-version = "windows server 2022"
}

parent_image = {
  owner = "core-shared-services-production"
  ami_search_filters = {
    name = ["mp_WindowsServer2022_*"]
  }
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
    path       = "../components/windows_server_2022_jumpserver/powershell_core.yml"
    parameters = []
    }, {
    path       = "../components/windows_server_2022_jumpserver/prometheus_windows_exporter.yml"
    parameters = []
    }, {
    path       = "../components/windows_server_2022_jumpserver/jumpserver.yml"
    parameters = []
  }
]

systems_manager_agent = {
  uninstall_after_build = false
}

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