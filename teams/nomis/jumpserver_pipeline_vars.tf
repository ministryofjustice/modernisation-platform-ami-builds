locals {
  jumpserver_pipeline = {
    version = "1.0.0"
    pipeline = {
      name     = join("", [local.team_name, "_jumpserver_", replace(local.jumpserver_pipeline.version, ".", "_")])
      schedule = "cron(0 0 2 * ? *)"
    }

    recipe = {
      name         = join("", [local.team_name, "_WindowsServer2022"])
      parent_image = "arn:aws:imagebuilder:eu-west-2:${data.aws_caller_identity.current.account_id}:image/mp-windowsserver2022/x.x.x"
      version      = local.jumpserver_pipeline.version
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
      instance_types     = ["t3.large"]
      name               = join("", [local.team_name, "_jumpserver_", replace(local.jumpserver_pipeline.version, ".", "_")])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = "${data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]}"
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_jumpserver_", replace(local.jumpserver_pipeline.version, ".", "_")])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_jumpserver_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "jumpserver.yml"
    ]

    aws_components = [
      "amazon-cloudwatch-agent-windows",
      "ec2launch-v2-windows"
    ]

  }

}
