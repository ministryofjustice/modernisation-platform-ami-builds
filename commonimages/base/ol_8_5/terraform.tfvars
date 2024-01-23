# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 
configuration_version = "0.0.8"
description           = "shared oracle linux 8.5 base image"

ami_base_name = "ol_8_5"

tags = {
  os-version = "ol 8.5"
  owner      = "probation-webops@digital.justice.gov.uk"
}

parent_image = {
  owner = "131827586825" # Oracle 
  ami_search_filters = {
    name = ["OL8.5-x86_64-*"]
  }
}

block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 30
    volume_type = "gp3"
  }
]

components_aws = []

components_custom = []

launch_template_exists = false

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}
