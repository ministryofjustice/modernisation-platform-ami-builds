locals {

  pipeline = {
    name     = "TestPipeline"
    schedule = "cron(0 0 * * ? *)"
  }


  recipe = {
    name         = "example"
    parent_image = "arn:aws:imagebuilder:eu-west-2:aws:image/amazon-linux-2-x86/x.x.x"
    version      = "1.0.1"
    device_name  = "/dev/xvdb"

    ebs = {
      delete_on_termination = true
      volume_size = 100
      volume_type = "gp2"
    }

  }


  infra_config = {
    description             = "Description here"
    instance_types          = ["t2.nano", "t3.micro"]
    name                    = "TestInfraConfig"
    security_group_ids      = ["sg-0c2fc68feb53f0122"]
    subnet_id               = "subnet-07e6dac6dd1c1e8b5"
    terminate_on_fail       = true
  }


  distribution = {
    name     = "TestDistributionConfig"
    region   = "eu-west-2"
    ami_name = "TestAMI-{{ imagebuilder:buildDate }}"
  }


  component_files = fileset(path.module, "components/*")
  component_files_trimmed = [ for file in fileset(path.module, "components/*") : trimsuffix( trimprefix(file, "components/"), ".yml") ]
  component_data  = [ for file in local.component_files: yamldecode(file("${path.module}/${file}")) ]

}
