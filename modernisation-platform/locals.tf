data "aws_organizations_organization" "root_account" {}
data "aws_caller_identity" "current" {}

locals {
  root_account           = data.aws_organizations_organization.root_account
  application_name       = "core-sandbox"
  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

  environment   = trimprefix(terraform.workspace, "${var.networking[0].application}-")
  provider_name = "core-vpc-development"

  # This takes the name of the Terraform workspace (e.g. core-vpc-production), strips out the application name (e.g. core-vpc), and checks if
  # the string leftover is `-production`, if it isn't (e.g. core-vpc-non-production => -non-production) then it sets the var to false.
  is-production    = substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-production"
  is-preproduction = substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-preproduction"
  is_live          = [substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-production" || substr(terraform.workspace, length(local.application_name), length(terraform.workspace)) == "-preproduction" ? "live" : "non-live"]

  tags = {
    business-unit = "Platforms"
    application   = "Modernisation Platform: ${terraform.workspace}"
    is-production = local.is-production
    owner         = "Modernisation Platform: modernisation-platform@digital.justice.gov.uk"
  }

  json_data = jsondecode(file("networking.auto.tfvars.json"))

  root_users_with_state_access = [
    "arn:aws:iam::${local.root_account.master_account_id}:user/ModernisationPlatformOrganisationManagement",
    "arn:aws:iam::${local.root_account.master_account_id}:user/DavidElliott"
  ]

  ami_share_accounts = [ for account, id in local.environment_management.account_ids : id ]

  base_component_dir = "../../../components"

}
