locals {

  rhel6_pipeline = {

    pipeline = {
      name     = join("", [local.team_name, "_RHEL6_10"])
      schedule = "rate(1 hour)"
    }

    recipe = {
      name           = join("", [local.team_name, "_RHEL6_10"])
      parent_account = "309956199498" #RedHat
      # parent_image = "arn:aws:imagebuilder:eu-west-2:${data.aws_caller_identity.current.account_id}:image/mp-amazonlinux2/x.x.x"
      version = "1.1.7"
      # device_name = "/dev/sda1"

      # ebs = {
      #   delete_on_termination = true
      #   volume_size           = 30
      #   volume_type           = "gp2"
      #   encrypted             = true
      #   kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
      # }

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
      description        = "RHEL 6_10 Base Image for Weblogic"
      instance_types     = ["t2.medium"]
      name               = join("", [local.team_name, "_RHEL6_10v1"])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = "${data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]}"
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_RHEL6_10v1"])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_RHEL6_10_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "rhel6.yml"
    ]

    aws_components = []

  }

}
