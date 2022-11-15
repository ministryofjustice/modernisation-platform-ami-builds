
ami_name_prefix = "base"


block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 2
    volume_type = "gp3"
  }
]

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

account_to_distribute_ami = "core-shared-services-production"

launch_permission_account_names = [
  "core-shared-services-production",
  "nomis-development",
  "nomis-test",
  "oasys-development",
  "oasys-test"
]