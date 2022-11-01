
region = "eu-west-2"

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 2
    volume_type = "gp3"
  }
]

user_data = null

components_aws = [
  "update-linux",
  "stig-build-linux-medium",
  "aws-cli-version-2-linux",
  "amazon-cloudwatch-agent-linux"
]

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 1 * ? *)"
  }
}

accounts_to_distribute_ami_by_branch = {
  main = [
    "core-shared-services-production"
  ]
  default = [
    "core-shared-services-production"
  ]
}