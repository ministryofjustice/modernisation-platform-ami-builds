# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

configuration_version = "0.0.8"
description           = "shared rhel 6.10 base image"

ami_base_name = "rhel_6_10"

tags = {
  os-version = "rhel 6.10"
  owner      = "digital-studio-operations-team@digital.justice.gov.uk"
}

parent_image = {
  owner = "309956199498" # Redhat
  ami_search_filters = {
    name = ["RHEL-6.10_HVM-*"]
  }
}

# rhel6.10 cannot use amazon-ssm-agent, this is installed via user_data
components_aws = [
  "update-linux",
]

components_custom = [
  {
    path       = "./components/rhel_6_10/stig_rhel6_ansible.yml.tftpl"
    parameters = []
  }
]

launch_template_exists = false

systems_manager_agent = {
  uninstall_after_build = false
}

user_data = <<EOF
#!/bin/bash
install_ssm_agent() {
  sudo yum install -y https://s3.eu-west-2.amazonaws.com/amazon-ssm-eu-west-2/3.0.1390.0/linux_amd64/amazon-ssm-agent.rpm
  sudo start amazon-ssm-agent
}
echo "install_ssm_agent start" | logger -p local3.info -t user-data
install_ssm_agent 2>&1 | logger -p local3.info -t user-data
echo "install_ssm_agent end" | logger -p local3.info -t user-data
EOF


infrastructure_configuration = {
  instance_types = ["t2.large"]
}
