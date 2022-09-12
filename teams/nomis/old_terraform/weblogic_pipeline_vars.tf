locals {
  version = "1.1.9" # change this value every time you update this file or the weblogic_pipeline.tf file

  # Ideally these values should be pulled from the weblogic component file or the ansible when it is changed in DSOS-1446
  os_version              = "RHEL6.10"
  middleware              = "WebLogicAppServer"
  weblogic_server_version = "10.3"
  release_or_patch        = "Patch" # IMPORTANT: use "Release" when the application NOMIS version changes, use "Patch" otherwise

  weblogic_pipeline = {

    pipeline = {
      name     = join("", [local.team_name, "_weblogic_", replace(local.version, ".", "_")])
      schedule = "rate(1 hour)"
    }

    recipe = {
      name           = join("", [local.team_name, "_weblogic"])
      parent_account = "309956199498" #RedHat
      version        = local.version

      ebs_block_device = [
        {
          device_name           = "/dev/sda1"
          volume_type           = "gp3"
          volume_size           = 30
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
        },
        {
          device_name           = "/dev/sdb"
          volume_type           = "gp3"
          volume_size           = 150
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
        }
      ]
    }

    infra_config = {
      description        = "RHEL 6_10 Image for Weblogic"
      instance_types     = ["t2.large"]
      name               = join("", [local.team_name, "_weblogic_", replace(local.version, ".", "_")])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = "${data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]}"
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_weblogic_", replace(local.version, ".", "_")])
      region   = "eu-west-2"
      ami_name = join("_", [replace(local.os_version, ".", "-"), local.middleware, replace(local.weblogic_server_version, ".", "-"), local.release_or_patch, "{{ imagebuilder:buildDate }}"])
    }

    components = [
      "weblogic.yml"
    ]

    aws_components = []

  }

}
