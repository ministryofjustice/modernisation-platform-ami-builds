# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  windows_server_2022_jumpserver = {
    configuration_version = "0.0.3"
    description           = "Windows Server 2022 jumpserver"

    tags = {
      os-version = "windows server 2022"
    }

    image_recipe = {
      parent_image = {
        owner             = "core-shared-services-production"
        filter_name_value = "mp_WindowsServer2022_*"
      }
      block_device_mappings_ebs = [
        {
          device_name = "/dev/sda1" # root volume
          volume_size = 30
          volume_type = "gp3"
        }
      ]
      components_aws = [
        "amazon-cloudwatch-agent-windows",
        "ec2launch-v2-windows"
      ]
      components_custom = [
        "../components/windows_server_2022_jumpserver/prometheus_windows_exporter.yml",
        "../components/windows_server_2022_jumpserver/jumpserver.yml"
      ]
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
        "nomis-test",
        "nomis-production"
      ]
    }

    launch_template_configuration = {
      account_id_or_name = "nomis-test"
      launch_template_id = "lt-0b4eec79084daf59f"
    }
  }

  # push to any other branch / local run
  default = {
    ami_distribution_configuration = {
      target_account_ids_or_names = [
        "core-shared-services-production",
        "nomis-development",
        "nomis-test",
        "nomis-production",
        "nomis-preproduction"
      ]
    }

    launch_template_configuration = {
      account_id_or_name = "nomis-test"
      launch_template_id = "lt-0b4eec79084daf59f"
    }
  }
}
