# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "delius"
ami_base_name         = "mis_windows_server"
configuration_version = "0.0.2"

release_or_patch = "patch" # see nomis AMI image building strategy doc
description      = "Delius MIS server"

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
  },
  {
    device_name = "/dev/xvdf" # this will map to the first drive in windows, D:
    volume_size = 7
    volume_type = "gp3",
    snapshot_id = "snap-04435aa8246764616" # Windows Server 2022 Installation Media
  },
]

components_aws = [
  "amazon-cloudwatch-agent-windows",
  "ec2launch-v2-windows"
]

components_custom = [
  {
    path       = "./components/mis_windows_server/delius_mis_set_system_locale.yml"
    parameters = []
  },
  {
    path       = "./components/mis_windows_server/add_net_framework_features.yml"
    parameters = []
  },
  {
    path       = "./components/mis_windows_server/delius_mis_configure_cloudwatch_agent.yml"
    parameters = []
  },
  {
    path       = "../../../commonimages/components/templates/psreadline_fix.yml"
    parameters = []
  },
  {
    path       = "../../../commonimages/components/templates/powershell_core.yml"
    parameters = []
  },
  {
    path       = "../../../commonimages/components/templates/git_windows.yml"
    parameters = []
  },
  {
    path       = "../../../commonimages/components/templates/nomis_windows_server.yml"
    parameters = []
  },
  {
    path       = "../../../commonimages/components/templates/nomis_windows_server_configure.yml"
    parameters = []
  },
  {
    path       = "../../../commonimages/components/templates/nomis_windows_server_configure_firewall.yml"
    parameters = []
  },
  {
    path       = "../../../commonimages/components/templates/nomis_windows_server_configure_awscli.yml"
    parameters = []
  },
  {
    path       = "../../../commonimages/components/templates/chocolatey.yml"
    parameters = []
  },
  {
    path = "../../../commonimages/components/templates/aws_cli.yml"
  }
]

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  schedule = {
    schedule_expression                = "cron(0 0 * * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

accounts_to_distribute_ami_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "delius-mis-development",
    "delius-mis-test",
    "delius-mis-preproduction",
    "delius-mis-production",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "delius-mis-development",
    "delius-mis-test",
    "delius-mis-preproduction",
    "delius-mis-production",
  ]
}

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "delius-mis-development",
    "delius-mis-test",
    "delius-mis-preproduction",
    "delius-mis-production",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "delius-mis-development",
    "delius-mis-test",
    "delius-mis-preproduction",
    "delius-mis-production",
  ]
}

launch_template_exists = false
