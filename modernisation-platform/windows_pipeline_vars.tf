locals {

  windows_pipeline = {

    pipeline = {
      name     = "MP_WindowsServer2022"
      schedule = "cron(0 0 1 * ? *)"
    }

    recipe = {
      name         = "MP_WindowsServer2022"
      parent_image = "arn:aws:imagebuilder:eu-west-2:aws:image/windows-server-2022-english-full-base-x86/x.x.x"
      version      = "1.0.3"
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
      name               = "MP_WindowsServer2022"
      security_group_ids = ["sg-0a3ea802b54cafc58"]
      subnet_id          = "subnet-0a198afa44c614a14"
      terminate_on_fail  = true
    }

    distribution = {
      name     = "MP_WindowsServer2022"
      region   = "eu-west-2"
      ami_name = "MP_WindowsServer2022_{{ imagebuilder:buildDate }}"
    }

    components = [
      "windows.yml"
    ]

    aws_components = [
      "chocolatey"
    ]

  }

}
