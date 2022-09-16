# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  rhel_6_10_baseimage = {
    configuration_version = "0.2.1"
    description           = "nomis RHEL6.10 base image"

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

      components_custom = [
        "../components/rhel_6_10_baseimage/rhel_6_10_baseimage.yml.tftpl"
      ]

      components_aws = [] # rhel6.10 cannot use AWS components, these are supplied below

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

    image_pipeline = {
      schedule = {
        schedule_expression = "cron(0 0 1 * ? *)"
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
        "nomis-test" #, "nomis-development"
      ]
    }

    launch_template_configuration = {
      account_id_or_name = "nomis-test"
      launch_template_id = "lt-05c9663f629ff1ba8"
    }
  }

  # push to any other branch / local run
  default = {
    ami_distribution_configuration = {
      target_account_ids_or_names = [
        "core-shared-services-production",
        "nomis-test" #, "nomis-development"
      ]
    }

    launch_template_configuration = {
      account_id_or_name = "nomis-test"
      launch_template_id = "lt-05c9663f629ff1ba8"
    }
  }
}
