locals {

  linux_pipeline = {

    pipeline = {
      name     = "Team1-LinuxPipeline"
      schedule = "cron(0 0 * * ? *)"
    }

    recipe = {
      name         = "Team1-LinuxRecipe"
      parent_image = "arn:aws:imagebuilder:eu-west-2:aws:image/amazon-linux-2-x86/x.x.x"
      version      = "1.0.9"
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
      name               = "Team1-Linux-InfraConfig"
      security_group_ids = ["sg-0c2fc68feb53f0122"]
      subnet_id          = "subnet-07e6dac6dd1c1e8b5"
      terminate_on_fail  = true
    }

    distribution = {
      name     = "Team1-Linux-DistributionConfig"
      region   = "eu-west-2"
      ami_name = "Team1-Linux-{{ imagebuilder:buildDate }}"
    }

    components = [
      "linux.yml"
    ]

  }

}
