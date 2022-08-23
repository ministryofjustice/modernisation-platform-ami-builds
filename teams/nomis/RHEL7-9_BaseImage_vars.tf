locals {
  RHEL7-9_BaseImage = {
    configuration_version = "1.0.5"
    description           = "nomis RHEL7.9 base image"

    tags = {
      os-version = "RHEL 7.9"
    }

    image_recipe = {
      parent_image = {
        owner             = "309956199498" # Redhat
        filter_name_value = "RHEL-7.9_HVM-*"
      }
      block_device_mappings_ebs = []
      components_aws = [
        "update-linux",
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
