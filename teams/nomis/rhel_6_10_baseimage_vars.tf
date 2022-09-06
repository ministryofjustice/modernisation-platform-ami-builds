locals {
  rhel_6_10_baseimage = {
    gh_actor              = var.GH_ACTOR_NAME
    branch                = var.BRANCH_NAME
    configuration_version = "0.0.7"
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
      components_aws = []
      # rhel6.10 cannot use AWS components, these are supplied via user_data below

      components_custom = [
        "components/rhel_6_10_baseimage.yml"
      ]

      user_data = <<EOF
#!/bin/bash
cd /tmp
sudo yum install -y https://s3.eu-west-2.amazonaws.com/amazon-ssm-eu-west-2/3.0.1390.0/linux_amd64/amazon-ssm-agent.rpm
sudo start amazon-ssm-agent
wget https://s3.eu-west-2.amazonaws.com/amazoncloudwatch-agent-eu-west-2/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
EOF

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
