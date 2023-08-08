# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

region                = "eu-west-2"
ami_name_prefix       = "hmpps"
ami_base_name         = "ol_8_5_oracledb_19c"
configuration_version = "0.0.2"
release_or_patch      = "release" # or "patch", see nomis AMI image building strategy doc
description           = "hmpps oracle 19c image on oracle linux 8.5"

tags = {
  os-version = "ol 8.5"
}

parent_image = {
  owner           = "core-shared-services-production"
  arn_resource_id = "base-ol-8-5/x.x.x"
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

components_aws = []

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

accounts_to_distribute_ami_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
    "oasys-preproduction",
    "oasys-production",
    "hmpps-oem-development",
    "hmpps-oem-test",
    "hmpps-oem-preproduction",
    "hmpps-oem-production",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-test",
    "corporate-staff-rostering-preproduction",
    "corporate-staff-rostering-production",
    "nomis-combined-reporting-development",
    "nomis-combined-reporting-test",
    "nomis-combined-reporting-preproduction",
    "nomis-combined-reporting-production",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
    "hmpps-oem-development",
    "hmpps-oem-test",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-test",
    "nomis-combined-reporting-development",
    "nomis-combined-reporting-test",
  ]
}

launch_permission_accounts_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
    "oasys-preproduction",
    "oasys-production",
    "hmpps-oem-development",
    "hmpps-oem-test",
    "hmpps-oem-preproduction",
    "hmpps-oem-production",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-test",
    "corporate-staff-rostering-preproduction",
    "corporate-staff-rostering-production",
    "nomis-combined-reporting-development",
    "nomis-combined-reporting-test",
    "nomis-combined-reporting-preproduction",
    "nomis-combined-reporting-production",
  ]

  # push to any other branch / local run
  default = [
    "core-shared-services-production",
    "oasys-development",
    "oasys-test",
    "hmpps-oem-development",
    "hmpps-oem-test",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-test",
    "nomis-combined-reporting-development",
    "nomis-combined-reporting-test",
  ]
}

launch_template_exists = false
