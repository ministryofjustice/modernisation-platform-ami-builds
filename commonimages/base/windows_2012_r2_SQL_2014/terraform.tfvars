# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_base_name         = "windows_server_2012_r2_SQL_2014_standard"
configuration_version = "0.0.1"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "Windows Server 2012 R2 with SQL 2014 Standard"

tags = {
  os-version = "windows server 2012 r2 with SQL 2014 Standard"
}

parent_image = {
  owner = "801119661308"
  ami_search_filters = {
    name = ["Windows_Server-2012-R2_RTM-English-64Bit-SQL_2014_SP3_Standard-*"] # specify as going EOL in 2023
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
  instance_types = ["t3.xlarge"] # SQL 2014 Minimum requirements 
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
  }
}

launch_template_exists = false
