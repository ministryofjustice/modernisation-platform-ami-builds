locals {

  linux_pipeline = {

    pipeline = {
      name     = join("", [local.team_name, "_AmazonLinux2"])
      schedule = "cron(0 0 * * ? *)"
    }

    recipe = {
      name         = join("", [local.team_name, "_AmazonLinux2"])
      parent_image = "arn:aws:imagebuilder:eu-west-2:${data.aws_caller_identity.current.account_id}:image/mp-amazonlinux2/x.x.x"
      version      = "1.0.1"
      device_name  = "/dev/xvda"

      ebs = {
        delete_on_termination = true
        volume_size           = 30
        volume_type           = "gp2"
        encrypted             = true
      }
    }

    infra_config = {
      description        = "Description here"
      instance_types     = ["t2.nano", "t3.micro"]
      name               = join("", [local.team_name, "_AmazonLinux2"])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id.non_live_data]
      subnet_id          = data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_AmazonLinux2"])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_AmazonLinux2_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "linux.yml"
    ]

    aws_components = [
      "yum-repository-test-linux"
    ]

  }

}
