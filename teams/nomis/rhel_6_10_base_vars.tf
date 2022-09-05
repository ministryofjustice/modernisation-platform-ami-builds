locals {
  rhel_6_10_base = {
    gh_actor              = var.GH_ACTOR_NAME
    branch                = var.BRANCH_NAME
    configuration_version = "0.0.2"
    description           = "nomis rhel 6.10 base image"

    tags = {
      os-version = "rhel 6.10"
    }

    image_recipe = {
      parent_image = {
        owner             = "309956199498" # Redhat
        filter_name_value = "RHEL-6.10_HVM-*"
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
        "components/rhel_6_10_base.yml"
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
