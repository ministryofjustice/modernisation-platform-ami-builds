# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

configuration_version = "0.0.2"
description           = "shared rhel 7.9 base image"

ami_base_name = "rhel_7_9"

tags = {
  os-version = "rhel 7.9"
  owner      = "digital-studio-operations-team@digital.justice.gov.uk"
}

parent_image = {
  owner = "309956199498" # Redhat
  ami_search_filters = {
    name = ["RHEL-7.9_HVM-*"]
  }
}

components_custom = [
  {
    path = "../components/rhel_7_9/packages.yml.tftpl"
    parameters = []
  },{
    path = "../components/rhel_7_9/python.yml.tftpl"
    parameters = []
  },{
    path = "../components/ansible.yml.tftpl"
    parameters = []
  }
]

launch_template_exists = false

systems_manager_agent = {
  uninstall_after_build = false
}
