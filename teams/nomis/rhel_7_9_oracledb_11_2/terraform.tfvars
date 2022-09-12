# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  # test configuration
  # needs EBS and components adding
  rhel_7_9_oracledb_11_2 = {
    configuration_version = "0.0.1"
    description           = "nomis rhel 7.9 oracleDB 11.2 image"

    tags = {
      os-version = "rhel 7.9"
    }

    image_recipe = {
      parent_image = {
        owner             = "core-shared-services-production"
        filter_name_value = "nomis_rhel_7_9_baseimage_*"
      }

      block_device_mappings_ebs = [
        {
          device_name = "/dev/sda1" # root volume
          volume_size = 30
          volume_type = "gp3"
        }
      ]

      components_custom = [
        "../components/database.yml.tmpl"
      ]

      components_aws = []
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

distribution_target_account_names_by_branch = {
  main = [
    "core-shared-services-production",
    "nomis-development",
    "nomis-test",
    "nomis-preproduction",
    "nomis-production",
  ]
  default = [
    "core-shared-services-production",
    "nomis-development"
  ]
}
