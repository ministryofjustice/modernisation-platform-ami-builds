# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 
configuration_version = "0.0.2"
description           = "shared rhel 8.5 base image arm64"

ami_base_name = "rhel_8_5_arm64"

tags = {
  os-version = "rhel 8.5"
  owner      = "digital-studio-operations-team@digital.justice.gov.uk"
}

parent_image = {
  owner = "309956199498" # Redhat
  ami_search_filters = {
    name = ["RHEL-8.5_HVM-*arm64*"]
  }
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 30
    volume_type = "gp3"
  }
]

components_aws = [
  "update-linux",
  "stig-build-linux-medium"
]

components_custom = []

launch_template_exists = false

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["r7g.medium"]
}
