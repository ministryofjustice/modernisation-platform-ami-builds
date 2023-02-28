# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 
configuration_version = "0.0.1"
description           = "shared rhel 8.7.0 base image"

ami_base_name = "rhel_8_7_0"

tags = {
  os-version = "rhel 8.7.0"
  owner      = "digital-studio-operations-team@digital.justice.gov.uk"
}

parent_image = {
  owner = "309956199498" # Redhat
  ami_search_filters = {
    name = ["RHEL-8.7.0_HVM-*"]
  }
}

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
  instance_types = ["t3.medium"]
}
