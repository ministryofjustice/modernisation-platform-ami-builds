locals {

  rhel_pipeline = {

    pipeline = {
      name     = join("", [local.team_name, "_rhel7"])
      schedule = "cron(0 0 * * ? *)"
    }

    recipe = {
      name         = join("", [local.team_name, "_rhel7"])
      parent_image = "arn:aws:imagebuilder:eu-west-2:aws:image/red-hat-enterprise-linux-7-x86/x.x.x"
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
      name               = join("", [local.team_name, "_rhel7"])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_rhel7"])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_rhel7_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "rhel7.yml"
    ]

    aws_components = [
      "aws-cli-version-2-linux",
      "python-3-linux",
      "amazon-cloudwatch-agent-linux",
      "update-linux-kernel-mainline",
      "update-linux"
    ]

  }

}
