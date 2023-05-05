
ami_name_prefix = "base"

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 30
    volume_type = "gp3"
  }
]

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 1 * ? *)"
  }
}

account_to_distribute_ami = "core-shared-services-production"

launch_permission_account_names = [
  "core-shared-services-production",
  "nomis-combined-reporting-development",
  "nomis-combined-reporting-test",
  "nomis-data-hub-development",
  "nomis-data-hub-test",
  "nomis-development",
  "nomis-test",
  "oasys-development",
  "oasys-preproduction",
  "oasys-production",
  "oasys-test",
  "delius-core-development"
]
