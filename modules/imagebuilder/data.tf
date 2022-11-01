data "terraform_remote_state" "core_shared_services_production" {
  backend = "s3"
  config = {
    bucket = "modernisation-platform-terraform-state"
    key    = "environments/accounts/core-shared-services/core-shared-services-production/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "imagebuilder_mp" {
  backend = "s3"
  config = {
    bucket = "modernisation-platform-terraform-state"
    key    = "environments/accounts/core-shared-services/core-shared-services-production/imagebuilder-mp.tfstate"
    region = "eu-west-2"
  }
}

data "aws_imagebuilder_component" "this" {
  for_each = toset(var.components_aws)
  arn      = "arn:aws:imagebuilder:${var.region}:aws:component/${each.key}/x.x.x"
}

data "aws_ami" "parent" {
  most_recent = true
  owners      = flatten([try(var.account_ids_lookup[var.parent_image.owner], var.parent_image.owner)])

  filter {
    name   = "name"
    values = [var.parent_image.filter_name_value]
  }
}

data "aws_launch_template" "this" {
  count = var.launch_template_exists ? 1 : 0
  name  = var.ami_base_name
}
