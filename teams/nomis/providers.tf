# AWS provider for the workspace you're working in (every resource will default to using this, unless otherwise specified)
provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.environment_management.account_ids[terraform.workspace]}:role/ModernisationPlatformAccess"
  }
}

# AWS provider for the Modernisation Platform, to get things from there if required
provider "aws" {
  alias  = "modernisation-platform"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "bucket-replication"
  region = "eu-west-1"
}

provider "aws" {
    alias = "nomis-test"
    region = "eu-west-2"
    assume_role {
        role_arn = "arn:aws:iam::${llocal.environment_management.account_ids["nomis-test"]}:role/NomisLaunchTemplateReaderRole"
    }
}