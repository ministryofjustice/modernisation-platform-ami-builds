# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

imagebuilders = {

  rhel_7_9_oracledb_11_2 = {
    configuration_version = "0.2.2"
    release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
    description           = "nomis rhel 7.9 oracleDB 11.2 image"

    tags = {
      os-version = "rhel 7.9"
    }

    image_recipe = {
      parent_image = {
        owner             = "core-shared-services-production"
        arn_resource_id   = "nomis-rhel-7-9-baseimage/x.x.x"
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

      components_aws = [
        "update-linux"
      ]

      components_custom = [
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
        "nomis-development",
        "nomis-test",
        "nomis-preproduction",
        "nomis-production"
      ]
    }
  }

  # push to any other branch / local run
  default = {
    ami_distribution_configuration = {
      target_account_ids_or_names = [
        "core-shared-services-production",
        "nomis-development",
        "nomis-test"
      ]
    }
  }
}
