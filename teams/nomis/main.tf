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
}

variable "distribution_target_account_names_by_branch" {
  description = "A map of github branch to corresponding list of account names, e.g. nomis-production.  You must specify default as a key which is used if the github branch is not defined in the map, e.g. in the case of a feature branch"
  # {
  #   main = [
  #     "core-shared-services-production",
  #     "nomis-development",
  #     "nomis-production"
  #   ]
  #   default = [
  #     "core-shared-services-production",
  #     "nomis-development"
  #   ]
  # }
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
    branch        = var.BRANCH_NAME
    is-production = "${var.BRANCH_NAME == "main" ? "true" : "false"}"
    owner         = "DSO: digital-studio-operations-team@digital.justice.gov.uk"
    source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/teams/nomis"
  }

  # configure the distribution account ids.  Different config is allowed
  # based on the github branch triggering the pipeline
  distribution_target_account_names = try(
    var.distribution_target_account_names_by_branch[var.BRANCH_NAME],
    var.distribution_target_account_names_by_branch["default"]
  )

  distribution_target_account_ids = distinct(flatten([
    for key in local.distribution_target_account_names :
    local.environment_management.account_ids[key]
  ]))

  distribution_configuration = {
    ami_distribution_configuration = {
      target_account_ids = local.distribution_target_account_ids
    }
  }
}

module "imagebuilder" {
  source   = "..//modules/imagebuilder"
  for_each = var.imagebuilders

  region                       = "eu-west-2"
  team_name                    = "nomis"
  name                         = each.key
  configuration_version        = each.value.configuration_version
  description                  = each.value.description
  release_or_patch             = lookup(each.value, "release_or_patch", "")
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
