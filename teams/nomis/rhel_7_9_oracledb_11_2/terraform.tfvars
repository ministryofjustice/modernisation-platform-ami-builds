# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  # test configuration
  # needs EBS and components adding
  rhel_7_9_oracledb_11_2 = {
    configuration_version = "0.0.5"
    release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
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
        },
        {
          device_name = "/dev/sdb" # /u01 oracle app disk
          volume_size = 100
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sdc" # /u02 oracle app disk
          volume_size = 100
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sds" # swap disk
          volume_size = 4
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sde" # oracle asm disk DATA01
          volume_size = 1
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sdf" # oracle asm disk DATA02
          volume_size = 1
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sdg" # oracle asm disk DATA03
          volume_size = 1
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sdh" # oracle asm disk DATA04
          volume_size = 1
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sdi" # oracle asm disk DATA05
          volume_size = 1
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sdj" # oracle asm disk FLASH01
          volume_size = 1
          volume_type = "gp3"
        },
        {
          device_name = "/dev/sdk" # oracle asm disk FLASH02
          volume_size = 1
          volume_type = "gp3"
        }
      ]

      components_custom = [
        "../components/rhel_7_9_oracledb_11_2/database.yml.tftpl"
      ]

      components_aws = []
    }

    infrastructure_configuration = {
      instance_types = ["t3.medium"]
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
