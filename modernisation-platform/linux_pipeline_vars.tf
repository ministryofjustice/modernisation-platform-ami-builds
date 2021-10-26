locals {

  linux_pipeline = {

    pipeline = {
      name     = "MP_AmazonLinux2"
      schedule = "cron(0 0 * * ? *)"
    }

    recipe = {
      name         = "MP_AmazonLinux2"
      parent_image = "arn:aws:imagebuilder:eu-west-2:aws:image/amazon-linux-2-x86/x.x.x"
      version      = "1.0.2"
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
      instance_types     = ["t3.medium"]
      name               = "MP_AmazonLinux2"
      security_group_ids = ["sg-0a3ea802b54cafc58"]
      subnet_id          = "subnet-0a198afa44c614a14"
      terminate_on_fail  = true
    }

    distribution = {
      name     = "MP_AmazonLinux2"
      region   = "eu-west-2"
      ami_name = "MP_AmazonLinux2_{{ imagebuilder:buildDate }}"
    }

    components = [
      "linux.yml"
    ]

    aws_components = [
      "aws-cli-version-2-linux",
      "python-3-linux",
      "amazon-cloudwatch-agent-linux",
      "update-linux-kernel-mainline",
      "update-linux",
      "stig-build-linux-high",
      "inspector-test-linux",
      "reboot-test-linux",
      "reboot-linux"
    ]

  }

}
