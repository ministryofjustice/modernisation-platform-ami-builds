# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 
configuration_version = "0.0.2"
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

components_aws = []

components_custom = []

launch_template_exists = false

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}
