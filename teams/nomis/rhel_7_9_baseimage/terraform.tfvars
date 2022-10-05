# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  rhel_7_9_baseimage = {
    configuration_version = "1.3.8"
    description           = "nomis RHEL7.9 base image"

    tags = {
      os-version = "rhel 7.9"
    }

    image_recipe = {
      parent_image = {
        owner             = "309956199498" # Redhat
        filter_name_value = "RHEL-7.9_HVM-*"
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
  # push to main branch
  main = {
    ami_distribution_configuration = {
      target_account_ids_or_names = [
        "core-shared-services-production",
        "nomis-test",
        "nomis-development"
      ]
    }

    launch_template_configuration = {
      account_id_or_name = "nomis-test"
      launch_template_id = "lt-05c9663f629ff1ba8"
    }
  }

  # push to any other branch / local run
  default = {
    ami_distribution_configuration = {
      target_account_ids_or_names = [
        "core-shared-services-production",
        "nomis-test",
        "nomis-development"
      ]
    }

    /* launch_template_configuration = {
      account_id_or_name = "nomis-test"
      launch_template_id = "lt-05c9663f629ff1ba8"
    } */
  }
}
