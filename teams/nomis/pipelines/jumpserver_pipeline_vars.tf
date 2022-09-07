locals {
  jumpserver_pipeline = {
    pipeline = {
      name     = join("", [local.team_name, "_jumpserver"])
      schedule = "cron(0 0 2 * ? *)" # day after source image is built
    }

    recipe = {
      name         = join("", [local.team_name, "_jumpserver"])
      parent_image = "arn:aws:imagebuilder:eu-west-2:${data.aws_caller_identity.current.account_id}:image/mp-windowsserver2022/x.x.x"
      version      = "1.0.5"
      device_name  = "/dev/sda1"

      ebs_block_device = [
        {
          device_name           = "/dev/sda1"
          volume_type           = "gp3"
          volume_size           = 30
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
        }
      ]
    }

    infra_config = {
      description        = "Windows Server 2022 Image for Jumpserver"
      instance_types     = ["t3.medium"]
      name               = join("", [local.team_name, "_jumpserver"])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = "${data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]}"
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_jumpserver_"])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_jumpserver_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "jumpserver.yml"
    ]

    aws_components = [
      "amazon-cloudwatch-agent-windows",
      "ec2launch-v2-windows",
    ]

  }

}
