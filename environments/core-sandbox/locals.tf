data "aws_organizations_organization" "root_account" {}

locals {
  application_name       = "core-sandbox"
  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

  environment = trimprefix(terraform.workspace, "${var.networking[0].application}-")
  provider_name = "core-vpc-development"

  # This takes the name of the Terraform workspace (e.g. core-vpc-production), strips out the application name (e.g. core-vpc), and checks if
  # the string leftover is `-production`, if it isn't (e.g. core-vpc-non-production => -non-production) then it sets the var to false.
  is-production    = substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-production"
  is-preproduction = substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-preproduction"
  is_live       = [substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-production" || substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-preproduction" ? "live" : "non-live"]

  tags = {
    business-unit = "Platforms"
    application   = "Modernisation Platform: ${terraform.workspace}"
    is-production = local.is-production
    owner         = "Modernisation Platform: modernisation-platform@digital.justice.gov.uk"
  }

  json_data = jsondecode(file("networking.auto.tfvars.json"))



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


}
