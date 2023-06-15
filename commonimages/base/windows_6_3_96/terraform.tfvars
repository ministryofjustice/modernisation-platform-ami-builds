# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 
configuration_version = "0.0.5"
description           = "base windows image"

ami_base_name = "windows_6_3_96"

tags = {
  os-version = "Windows 6.3"
  owner      = "probation-webops@digital.justice.gov.uk"
}

parent_image = "ami-0bc237d1e18c6c53d"

components_aws = []

components_custom = []

launch_template_exists = false

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}
