terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2"
    }
  }
  required_version = "=1.5.7"
}

provider "aws" {
  alias  = "modernisation-platform"
  region = "eu-west-2"
}

# AWS provider for the workspace you're working in (every resource will default to using this, unless otherwise specified)
provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.environment_management.account_ids[terraform.workspace]}:role/ModernisationPlatformAccess"
  }
}