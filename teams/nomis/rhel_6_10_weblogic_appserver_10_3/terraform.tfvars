# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  # test configuration
  # needs EBS and components adding
  rhel_6_10_weblogic_appserver_10_3 = {
    configuration_version = "0.0.1"
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

      components_custom = [
        "../components/rhel_6_10_weblogic_appserver_10_3/weblogic.yml.tmpl"
      ]

      components_aws = []
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

distribution_target_account_names_by_branch = {
  main = [
    "core-shared-services-production",
    "nomis-test",
    "nomis-production"
  ]
  default = [
    "core-shared-services-production",
    "nomis-test"
  ]
}
