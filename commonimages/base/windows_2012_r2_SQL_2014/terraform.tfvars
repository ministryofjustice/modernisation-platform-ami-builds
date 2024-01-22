# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_base_name         = "windows_server_2012_r2_SQL_2014_enterprise"
configuration_version = "0.0.7"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "Windows Server 2012 R2 with SQL 2014 Enterprise"

tags = {
  os-version = "windows server 2012 r2 with SQL 2014 Enterprise"
}

parent_image = {
  owner = "679593333241"
  ami_search_filters = {
    name = ["sc-a-216-5d93057e-941a-4d1b-884f-ec900151c1d1-230-5d93057e-941a-4d1b-884f-ec900151c1d1"] # AWS image not available so taken from marketplace. NOTE: This may fail at the build step if there is some sort of licensing restriction
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
]

components_custom = []

infrastructure_configuration = {
  instance_types = ["m4.xlarge"] # SQL 2014 Minimum requirements 
}

image_pipeline = {
  schedule = {
    schedule_expression                = "cron(0 0 2 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

launch_template_exists = false
