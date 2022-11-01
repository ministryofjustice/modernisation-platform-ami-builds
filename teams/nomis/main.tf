### Putting variables here to avoid too much symbolic linking

variable "BRANCH_NAME" {
  type        = string
  default     = "main"
  description = "Github actions running branch"
}

variable "GH_ACTOR_NAME" {
  type        = string
  default     = ""
  description = "GH username triggering Github action"
}

variable "imagebuilders" {
  description = "A map of imagebuilder configurations."
  type        = map(any)
}

variable "distribution_configuration_by_branch" {
  description = "A map of github branch to distribution_configuration.  See README for more details"
  type        = map(any)
}

### Core mod platform account stuff

provider "aws" {
  alias  = "modernisation-platform"
  region = "eu-west-2"
}

data "aws_secretsmanager_secret" "environment_management" {
  provider = aws.modernisation-platform
  name     = "environment_management"
}

data "aws_secretsmanager_secret_version" "environment_management" {
  provider  = aws.modernisation-platform
  secret_id = data.aws_secretsmanager_secret.environment_management.id
}

locals {
  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)
}

### Team specific stuff

# AWS provider for the workspace you're working in (every resource will default to using this, unless otherwise specified)
provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.environment_management.account_ids[terraform.workspace]}:role/ModernisationPlatformAccess"
  }
}

# Retrieve KMS key for AMI/snapshot encryption
data "aws_caller_identity" "current" {}
data "aws_kms_key" "hmpps_ebs_encryption_cmk" {
  key_id = "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/ebs-hmpps"
}

locals {
  team_name        = "nomis"
  application_name = "core-shared-services"
  environment      = trimprefix(terraform.workspace, "core-shared-services-")
  provider_name    = "core-vpc-development"

  # these are all based on https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html#tags-you-should-use
  tags = {
    business-unit = "HMPPS"
    application   = upper(local.team_name)
    branch        = var.BRANCH_NAME == "" ? "n/a" : var.BRANCH_NAME
    github-actor  = var.GH_ACTOR_NAME == "" ? "n/a" : var.GH_ACTOR_NAME
    is-production = var.BRANCH_NAME == "main" ? "true" : "false"
    owner         = "DSO: digital-studio-operations-team@digital.justice.gov.uk"
    source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/teams/nomis"
  }

  # Different distribution config is allowed based on the github branch
  # triggering the pipeline
  distribution_configuration = try(
    var.distribution_configuration_by_branch[var.BRANCH_NAME],
    var.distribution_configuration_by_branch["default"]
  )
}

module "imagebuilder" {
  source   = "..//modules/imagebuilder"
  for_each = var.imagebuilders

  region                       = "eu-west-2"
  team_name                    = "nomis"
  name                         = each.key
  configuration_version        = each.value.configuration_version
  description                  = each.value.description
  release_or_patch             = var.BRANCH_NAME != "main" ? "test" : lookup(each.value, "release_or_patch", "")
  tags                         = merge(local.tags, each.value.tags)
  kms_key_id                   = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
  account_ids_lookup           = local.environment_management.account_ids
  image_recipe                 = each.value.image_recipe
  infrastructure_configuration = each.value.infrastructure_configuration
  distribution_configuration   = local.distribution_configuration
  image_pipeline               = each.value.image_pipeline
  branch                       = var.BRANCH_NAME
  gh_actor                     = var.GH_ACTOR_NAME
}

output "parent_ami" {
  value       = { for key, value in module.imagebuilder : key => value.parent_ami }
  description = "parent AMI details"
}
