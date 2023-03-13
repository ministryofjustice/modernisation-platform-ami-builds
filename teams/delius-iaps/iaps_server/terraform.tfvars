# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "delius"
ami_base_name         = "iaps_server"
configuration_version = "0.0.18"
release_or_patch      = "patch" # see nomis AMI image building strategy doc
description           = "Delius IAPS server"

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
    path       = "./components/iaps_server/add_net_framework_features.yml"
    parameters = []
  },
  {
    path       = "./components/iaps_server/delius_iaps_install_base_packages.yml"
    parameters = []
  },
  {
    path = "./components/iaps_server/delius_iaps_install_oracle_db_client_tools.yml"
    parameters = [
      {
        name  = "S3ArtefactBucket"
        value = "mod-platform-image-artefact-bucket20230203091453221500000001"
      }
    ]
  },
  {
    path       = "./components/iaps_server/delius_iaps_configure_odbcdns.yml"
    parameters = []
  },
  {
    path = "./components/iaps_server/delius_iaps_install_oracle_sql_developer.yml"
    parameters = [
      {
        name  = "S3ArtefactBucket"
        value = "mod-platform-image-artefact-bucket20230203091453221500000001"
      }
    ]
  },
  {
    path = "./components/iaps_server/delius_iaps_install_im_interface.yml"
    parameters = [
      {
        name  = "S3ArtefactBucket"
        value = "mod-platform-image-artefact-bucket20230203091453221500000001"
      }
    ]
  },
  {
    path       = "./components/iaps_server/delius_iaps_configure_cloudwatch_agent.yml"
    parameters = []
  },
  {
    path = "./components/iaps_server/delius_iaps_add_manual.yml"
    parameters = [
      {
        name  = "S3ArtefactBucket"
        value = "mod-platform-image-artefact-bucket20230203091453221500000001"
      }
    ]
  },
  {
    path = "./components/iaps_server/delius_iaps_install_ndelius_interface.yml"
    parameters = [
      {
        name  = "S3ArtefactBucket"
        value = "mod-platform-image-artefact-bucket20230203091453221500000001"
      }
    ]
  },
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
    "delius-iaps-development",
    "delius-iaps-preproduction",
    "delius-iaps-production"
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "delius-iaps-development",
    "delius-iaps-preproduction",
    "delius-iaps-production"
  ]
}

launch_template_exists = false
