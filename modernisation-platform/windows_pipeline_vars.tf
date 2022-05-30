locals {

  windows_pipeline = {

    pipeline = {
      name     = join("", [local.team_name, "_WindowsServer2022"])
      schedule = "cron(0 0 1 * ? *)"
    }

    recipe = {
      name         = join("", [local.team_name, "_WindowsServer2022"])
      parent_image = "arn:aws:imagebuilder:eu-west-2:aws:image/windows-server-2022-english-full-base-x86/x.x.x"
      version      = "1.0.1"
      device_name  = "/dev/sda1"

      ebs = {
        delete_on_termination = true
        volume_size           = 30
        volume_type           = "gp2"
        encrypted             = true
      }
    }

    infra_config = {
      description        = "Description here"
      instance_types     = ["t3.medium"]
      name               = join("", [local.team_name, "_WindowsServer2022"])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = "${data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]}"
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_WindowsServer2022"])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_WindowsServer2022_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "windows.yml"
    ]

    # Removed "stig-build-windows-medium" because current version 1.5.1 does not support the Parent Image OS Version of Microsoft Windows Server 2022
    # For more info refer to https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-stig.html
    aws_components = [
      "chocolatey"
    ]

  }

}
