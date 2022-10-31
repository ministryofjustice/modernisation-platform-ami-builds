# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 



# need to consider having over versions of images? do we need to maintain the code for old images? fire and forget images, much like git releases? With a deletion policy

configuration_version = "0.0.1"
description           = "oasys RHEL7.9 base image"

tags = {
  os-version = "rhel 7.9"
}

parent_image = {
  owner             = "309956199498" # Redhat
  filter_name_value = "RHEL-7.9_HVM-*"
}

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

components_custom = [
  "../components/rhel_7_9_baseimage/packages.yml",
  "../components/rhel_7_9_baseimage/python.yml",
  "../components/ansible.yml.tftpl"
]

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 1 * ? *)"
  }
}

launch_template_exists = false

accounts_to_distribute_ami_by_branch = {
  main = [
    #"core-shared-services-production",
    "oasys-development"
  ]
  default = [
    #"core-shared-services-production",
    "oasys-development"
  ]
}