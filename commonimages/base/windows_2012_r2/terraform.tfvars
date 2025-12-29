# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_base_name         = "windows_server_2012_r2"
configuration_version = "0.2.12"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "Windows Server 2012 R2"

tags = {
  os-version = "windows server 2012 r2"
}

parent_image = {
  owner = "374269020027"
  ami_search_filters = {
    name = ["base_windows_server_2012_r2_release_2023-12-01T*"] # specify our own Windows Server 2012 R2 base image as this went EOL in 2023
    # based off the retired: EC2LaunchV2-Windows_Server-2012_R2_RTM-English-Full-Base-*
  }
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 128
    volume_type = "gp3"
  },
  {
    device_name = "/dev/sdb" # new volume created
    volume_size = 100
    volume_type = "gp3"
  }
]

components_aws = [
  "amazon-cloudwatch-agent-windows"
  # "ec2launch-v2-windows" already baked into this ami
]

components_custom = []

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  # schedule = {
  #   schedule_expression                = "cron(0 0 2 * ? *)"
  #   pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  # }
}

launch_template_exists = false
