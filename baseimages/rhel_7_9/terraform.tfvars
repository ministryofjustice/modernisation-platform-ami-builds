# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 


configuration_version = "0.0.1"
description           = ""

tags = {
  os-version = "rhel 7.9"
  owner      = "digital-studio-operations-team@digital.justice.gov.uk"
}

parent_image = {
  owner             = "309956199498" # Redhat
  filter_name_value = "RHEL-7.9_HVM-*"
}

components_custom = [
  "../components/rhel_7_9_baseimage/packages.yml",
  "../components/rhel_7_9_baseimage/python.yml",
  "../components/ansible.yml.tftpl"
]

launch_template_exists = false