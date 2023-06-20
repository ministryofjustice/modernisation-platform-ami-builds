locals {

  # Recipe's version:
  windows_s3_test_recipe_version = "1.0.0"

  # Component's version:
  s3_operations_component_version = "1.0.0"

  windows_s3_test = {

    pipeline = {
      name     = join("", [local.team_name, "_WindowsServer2012_s3_test"])
      schedule = "cron(0 0 2 * ? *)" # day after source image is built
    }

    recipe = {
      name         = join("", [local.team_name, "_WindowsServer2012_s3_test"])
      parent_image = "arn:aws:imagebuilder:eu-west-2:${local.environment_management.account_ids["core-shared-services-production"]}:image/mp-windowsserver2022/x.x.x"
      version      = local.windows_s3_test_recipe_version
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
      name               = join("", [local.team_name, "_WindowsServer2012_s3_test"])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_WindowsServer2012_s3_test"])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_WindowsServer2012_s3_test_{{ imagebuilder:buildDate }}"])
    }

    components = [
      {
        document = "s3_operations.yml",
        parameters = {
          Version  = local.s3_operations_component_version,
          S3bucket = "mod-platform-image-artefact-bucket20230203091453221500000001" //TODO S3 bucket name could be retrieved from data.terraform_remote_state.modernisation-platform-repo if the bucket name output was specified
          Key      = "example-${local.team_name}/test"
          FilePath = "C:\\Windows\\TEMP\\test"
        }
      }
    ]

    # Removed "stig-build-windows-medium" because current version 1.5.1 does not support the Parent Image OS Version of Microsoft Windows Server 2022
    # For more info refer to https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-stig.html
    # Not needed for this example, as the base AMI is the MP AMI with some software already installed.
    aws_components = []

  }
}
