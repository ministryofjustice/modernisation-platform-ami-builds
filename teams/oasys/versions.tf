terraform {
  experiments = [module_variable_optional_attrs]
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "=1.0.0"
}

provider "aws" {
  alias  = "modernisation-platform"
  region = "eu-west-2"
}

# AWS provider for the workspace you're working in (every resource will default to using this, unless otherwise specified)
provider "aws" { # PUT THIS IN PROVIDER FILE AND SYMLINK TO DIRS
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.environment_management.account_ids[terraform.workspace]}:role/ModernisationPlatformAccess"
  }
}