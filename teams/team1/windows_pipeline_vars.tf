locals {

  windows_pipeline = {

    pipeline = {
      name     = "Team1_WindowsServer2022"
      schedule = "cron(0 0 1 * ? *)"
    }

    recipe = {
      name         = "Team1_WindowsServer2022"
      parent_image = "arn:aws:imagebuilder:eu-west-2:763252494486:image/mp-windowsserver2022/x.x.x"
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
      instance_types     = ["t2.nano", "t3.micro"]
      name               = "Team1_WindowsServer2022"
      security_group_ids = ["sg-0c2fc68feb53f0122"]
      subnet_id          = "subnet-07e6dac6dd1c1e8b5"
      terminate_on_fail  = true
    }

    distribution = {
      name     = "Team1_WindowsServer2022"
      region   = "eu-west-2"
      ami_name = "Team1_WindowsServer2022_{{ imagebuilder:buildDate }}"
    }

    components = [
      "windows.yml"
    ]

    aws_components = [
      "chocolatey"
    ]

  }

}
