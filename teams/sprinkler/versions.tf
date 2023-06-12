terraform {
  experiments = [module_variable_optional_attrs]
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
  required_version = "~> 1.0"
}