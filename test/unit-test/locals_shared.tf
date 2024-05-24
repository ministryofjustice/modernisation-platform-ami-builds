data "http" "environments_file" {
  url = "https://raw.githubusercontent.com/ministryofjustice/modernisation-platform/main/environments/${local.application_name}.json"
}

locals {

  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

  team_name        = "testing"
  application_name = "core-shared-services"
  environment      = trimprefix(terraform.workspace, "core-shared-services-")
  provider_name    = "core-vpc-development"

  # these are all based on https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html#tags-you-should-use
  shared_tags = {
    business-unit = "Platforms"
    application   = upper(local.team_name)
    branch        = "main"
    is-production = var.BRANCH_NAME == "main" ? "true" : "false"
    owner         = "Modernisation Platform: modernisation-platform@digital.justice.gov.uk"
    source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main"
  }

  # accounts_to_distribute_ami = try(
  #   var.accounts_to_distribute_ami_by_branch[var.BRANCH_NAME],
  #   var.accounts_to_distribute_ami_by_branch["default"],
  #   [var.account_to_distribute_ami]
  # )

  #   launch_permission_account_names = try(
  #     var.launch_permission_accounts_by_branch[var.BRANCH_NAME],
  #     var.launch_permission_accounts_by_branch["default"]
  #   )
}
