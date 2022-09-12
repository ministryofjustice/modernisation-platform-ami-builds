# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  rhel_7_9_baseimage = {
    configuration_version = "1.2.2"
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
        "../components/rhel_7_9_baseimage/rhel_7_9_baseimage.yml"
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

distribution_target_account_names_by_branch = {
  main = [
    "core-shared-services-production",
    "nomis-test"
  ]
  default = [
    "core-shared-services-production",
    "nomis-test"
  ]
}
