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
  for_each = toset(var.image_recipe.components_aws)
  arn      = "arn:aws:imagebuilder:${var.region}:aws:component/${each.key}/x.x.x"
}

data "aws_ami" "parent" {
  count       = var.image_recipe.parent_image.filter_name_value != null ? 1 : 0
  most_recent = true
  owners      = [local.ami_parent_id]

  filter {
    name   = "name"
    values = [var.image_recipe.parent_image.filter_name_value]
  }
}
