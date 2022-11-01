# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  rhel_7_9_baseimage = {
    configuration_version = "1.4.4"
    description           = "nomis RHEL7.9 base image"

    tags = {
      os-version = "rhel 7.9"
      dummy-tag  = "delete me"
    }

    image_recipe = {
      parent_image = {
        # NOTE: this picks up the latest RHEL image at the time the terraform
        # is run.  Increment version number and re-run the pipeline when a new
        # version is released by RedHat.
        owner = "309956199498" # Redhat
        ami_search_filters = {
          name = ["RHEL-7.9_HVM-*"]
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
        "stig-build-linux-medium",
        "aws-cli-version-2-linux",
        "amazon-cloudwatch-agent-linux"
      ]
      components_custom = [
        "../components/rhel_7_9_baseimage/packages.yml",
        "../components/rhel_7_9_baseimage/python.yml",
        "../components/ansible.yml.tftpl"
      ]
      systems_manager_agent = {
        uninstall_after_build = false
      }
    }

    infrastructure_configuration = {
      instance_types = ["t3.medium"]
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
      launch_template_id = "lt-0ffc91d476d458bbc"
    }
  }
}
