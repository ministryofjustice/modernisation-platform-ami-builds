locals {
  RHEL7-9_BaseImage = {
    gh_actor              = var.GH_ACTOR_NAME
    branch                = var.BRANCH_NAME
    configuration_version = "1.1.5"
    description           = "nomis RHEL7.9 base image"

    tags = {
      os-version = "RHEL 7.9"
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
        "components/RHEL7-9_BaseImage.yml"
      ]
    }

    infrastructure_configuration = {
      instance_types = ["t2.large"]
    }

    distribution_configuration = {
      ami_distribution_configuration = {
        target_account_ids = local.ami_share_accounts
      }
    }

    image_pipeline = {
      schedule = {
        schedule_expression = "cron(0 0 1 * ? *)"
      }
    }
  }
}
