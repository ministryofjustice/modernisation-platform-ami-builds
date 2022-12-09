# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

region                = "eu-west-2"
ami_name_prefix       = "nomis"
ami_base_name         = "rhel_7_9_oracledb_11_2"
configuration_version = "0.2.0"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "nomis rhel 6.10 weblogic appserver image"

tags = {
  os-version = "rhel 6.10"
}

parent_image = {
  owner = "core-shared-services-production"
  ami_search_filters = {
    name = ["base_rhel_6_10_*"]
  }
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

components_aws = [
  "update-linux"
]

components_custom = [
  "../components/rhel_6_10_weblogic_appserver_10_3/weblogic.yml"
]

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t2.large"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
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
        "nomis-production"
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
        "nomis-test"
      ]
    }
  }
}










components_custom = []

systems_manager_agent = {
  uninstall_after_build = false
}

infrastructure_configuration = {
  instance_types = ["t3.medium"]
}

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 2 * ? *)"
  }
}

account_to_distribute_ami = "core-shared-services-production"

launch_permission_account_names = [
  "core-shared-services-production",
  "nomis-development",
  "nomis-test",
  "oasys-development",
  "oasys-test"
]

launch_template_exists = false