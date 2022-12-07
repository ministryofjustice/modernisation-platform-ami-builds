# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

imagebuilders = {

  windows_server_2022_jumpserver = {
    configuration_version = "0.1.0"
    description           = "Windows Server 2022 jumpserver"

    tags = {
      os-version = "windows server 2022"
    }

    image_recipe = {
      parent_image = {
        owner           = "core-shared-services-production"
        arn_resource_id = "mp-windowsserver2022/x.x.x"
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
        "../components/windows_server_2022_jumpserver/powershell_core.yml",
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
      target_account_names = [
        "core-shared-services-production"
      ]
      launch_permission_account_names = [
        "core-shared-services-production",
        "nomis-development",
        "nomis-test",
        "nomis-preproduction",
        "nomis-production",
        "oasys-development",
        "oasys-test",
        "oasys-preproduction",
        "oasys-production"
      ]
    }
  }

  # push to any other branch / local run
  default = {
    ami_distribution_configuration = {
      target_account_names = [
        "core-shared-services-production"
      ]
      launch_permission_account_names = [
        "core-shared-services-production",
        "nomis-development",
        "nomis-test",
        "oasys-development",
        "oasys-test"
      ]
    }
  }

}
