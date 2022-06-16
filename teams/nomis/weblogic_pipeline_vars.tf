locals {
  version = "1.1.4"
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
          kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
          delete_on_termination = true
        },
        {
          device_name           = "/dev/sdb"
          volume_type           = "gp3"
          volume_size           = 150
          encrypted             = true
          kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
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
      ami_name = join("", [local.team_name, "_Weblogic_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "weblogic.yml"
    ]

    aws_components = []

  }

}
