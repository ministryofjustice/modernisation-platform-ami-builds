# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_base_name         = "windows_server_2012_r2"
configuration_version = "0.0.4"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "Windows Server 2012 R2"

tags = {
  os-version = "windows server 2012 r2"
}

parent_image = {
  owner = "801119661308"
  ami_search_filters = {
    name = ["Windows_Server-2012-R2_RTM-*"]
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
  "amazon-cloudwatch-agent-windows",
  "ec2launch-v2-windows"
]

components_custom = []

infrastructure_configuration = {
  instance_types = ["t3.xlarge"] # Windows SQL Server Enterprise minimum requirements, 2012 R2 won't build unless these are met...
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
  }
}


launch_template_exists = false
