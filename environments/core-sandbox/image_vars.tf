locals {

  pipeline = {
    name     = "TestPipeline"
    schedule = "cron(0 0 * * ? *)"
  }


  recipe = {
    name         = "example"
    parent_image = "arn:aws:imagebuilder:eu-west-2:aws:image/amazon-linux-2-x86/x.x.x"
    version      = "1.0.7"
    device_name  = "/dev/xvdb"

    ebs = {
      delete_on_termination = true
      volume_size           = 100
      volume_type           = "gp2"
      encrypted             = true
    }

  }


  infra_config = {
    description        = "Description here"
    instance_types     = ["t2.nano", "t3.micro"]
    name               = "TestInfraConfig"
    security_group_ids = ["sg-0c2fc68feb53f0122"]
    subnet_id          = "subnet-07e6dac6dd1c1e8b5"
    terminate_on_fail  = true
  }


  distribution = {
    name     = "TestDistributionConfig"
    region   = "eu-west-2"
    ami_name = "TestAMI-{{ imagebuilder:buildDate }}"
  }

  // need a map of: file_name = version

  component_map = {
    "hello_world1" = "1.0.4"
    "hello_world2" = "1.0.4"
  }

  ami_share_accounts = [
    "${local.environment_management.account_ids["core-shared-services-production"]}"
  ]

}
