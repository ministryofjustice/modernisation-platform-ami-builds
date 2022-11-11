# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

imagebuilders = {

  rhel_6_10_baseimage = {
    configuration_version = "0.5.5"
    description           = "nomis RHEL6.10 base image"

    tags = {
      os-version = "rhel 6.10"
    }

    image_recipe = {
      parent_image = {
        # NOTE: this picks up the latest RHEL image at the time the terraform
        # is run.  Increment version number and re-run the pipeline when a new
        # version is released by RedHat.
        owner = "309956199498" # Redhat
        ami_search_filters = {
          name = ["RHEL-6.10_HVM-*"]
        }
      }
      block_device_mappings_ebs = [
        {
          device_name = "/dev/sda1" # root volume
          volume_size = 30
          volume_type = "gp3"
        }
      ]

      # rhel6.10 cannot use amazon-ssm-agent, this is installed via user_data
      components_aws = [
        "update-linux",
      ]

      components_custom = [
        "../components/rhel_6_10_baseimage/packages.yml",
        "../components/rhel_6_10_baseimage/python.yml",
        "../components/ansible.yml.tftpl",
        "../components/rhel_6_10_baseimage/stig_rhel6_ansible.yml.tftpl"
      ]

      # SSM agent must be installed via user_data prior to components being run
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

      systems_manager_agent = {
        uninstall_after_build = false
      }
    }

    infrastructure_configuration = {
      instance_types = ["t2.large"]
    }

    image_pipeline = {
      schedule = {
        schedule_expression = "cron(0 0 1 * ? *)"
      }
    }
  }
}

distribution_configuration_by_branch = {
  default = {
    ami_distribution_configuration = {
      target_account_names = [
        "core-shared-services-production"
      ]
      launch_permission_account_names = [
        "core-shared-services-production",
        "nomis-development",
        "nomis-test",
        "oasys-development",
        "oasys-test"
      ]
    }

    launch_template_configuration = {
      account_name       = "nomis-development"
      launch_template_id = "lt-04af9b9914ae9a578"
    }
  }
}
