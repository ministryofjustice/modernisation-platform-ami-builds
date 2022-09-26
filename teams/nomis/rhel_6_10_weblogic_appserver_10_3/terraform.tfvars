# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  # test configuration
  # needs EBS and components adding
  rhel_6_10_weblogic_appserver_10_3 = {
    configuration_version = "0.0.7"
    release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
    description           = "nomis rhel 6.10 weblogic appserver image"

    tags = {
      os-version = "rhel 6.10"
    }

    image_recipe = {
      parent_image = {
        owner             = "core-shared-services-production"
        filter_name_value = "nomis_rhel_6_10_baseimage_*"
      }

      block_device_mappings_ebs = [
        {
          device_name = "/dev/sda1" # root volume
          volume_size = 30
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sdb"
          volume_size = 150
          volume_type = "gp3"
        }
      ]

      components_aws = [
        "update-linux",
      ]

      components_custom = [
        "../components/ansible.yml.tftpl",
        "../components/rhel_6_10_weblogic_appserver_10_3/weblogic.yml"
      ]

    }

    infrastructure_configuration = {
      instance_types = ["t2.large"]
    }

    image_pipeline = {
      schedule = {
        schedule_expression = "cron(0 0 2 * ? *)"
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
        "nomis-production"
      ]
    }
  }

  # push to any other branch / local run
  default = {
    ami_distribution_configuration = {
      target_account_ids_or_names = [
        "core-shared-services-production",
        "nomis-test"
      ]
    }
  }
}
