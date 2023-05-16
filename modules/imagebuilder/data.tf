data "aws_secretsmanager_secret" "environment_management" {
  provider = aws.modernisation-platform
  name     = "environment_management"
}

data "aws_secretsmanager_secret_version" "environment_management" {
  provider  = aws.modernisation-platform
  secret_id = data.aws_secretsmanager_secret.environment_management.id
}

# Retrieve KMS key for AMI/snapshot encryption
data "aws_caller_identity" "current" {}
data "aws_kms_key" "hmpps_ebs_encryption_cmk" {
  key_id = "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/ebs-hmpps"
}

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
  count       = var.parent_image.ami_search_filters != null ? 1 : 0
  most_recent = true
  owners      = [local.ami_parent_id]
  include_deprecated = true

  dynamic "filter" {
    for_each = var.parent_image.ami_search_filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}
