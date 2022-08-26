data "aws_organizations_organization" "root_account" {}
data "aws_caller_identity" "current" {}

locals {

  team_name = "nomis"

  root_account           = data.aws_organizations_organization.root_account
  application_name       = "core-shared-services"
  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

  environment   = trimprefix(terraform.workspace, "${var.networking[0].application}-")
  provider_name = "core-vpc-development"

  # This takes the name of the Terraform workspace (e.g. core-vpc-production), strips out the application name (e.g. core-vpc), and checks if
  # the string leftover is `-production`, if it isn't (e.g. core-vpc-non-production => -non-production) then it sets the var to false.
  is-production    = substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-production"
  is-preproduction = substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-preproduction"
  is_live          = [substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-production" || substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-preproduction" ? "live" : "non-live"]

  # these are all based on https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html#tags-you-should-use
  tags = {
    business-unit = "HMPPS"
    application   = upper(local.team_name)
    is-production = local.is-production
    owner         = "DSO: digital-studio-operations-team@digital.justice.gov.uk"
    source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/teams/nomis"
  }

  ami_share_accounts = flatten([[
    local.environment_management.account_ids["core-shared-services-production"],
    local.environment_management.account_ids["nomis-test"]],
    var.BRANCH_NAME == "main" ? [local.environment_management.account_ids["nomis-production"]] : []])

}
