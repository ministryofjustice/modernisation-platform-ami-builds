locals {
  team_name        = "delius-iaps"
  application_name = "core-shared-services"
  environment      = trimprefix(terraform.workspace, "core-shared-services-")
  provider_name    = "core-vpc-development"

  # these are all based on https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html#tags-you-should-use
  shared_tags = {
    business-unit = "HMPPS"
    application   = upper(local.team_name)
    branch        = var.BRANCH_NAME == "" ? "n/a" : var.BRANCH_NAME
    is-production = var.BRANCH_NAME == "main" ? "true" : "false"
    owner         = "Probation Webops: probation-webops@digital.justice.gov.uk"
    source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/teams/delius-iaps"
  }

  launch_permission_account_names = try(
    var.launch_permission_accounts_by_branch[var.BRANCH_NAME],
    var.launch_permission_accounts_by_branch["default"]
  )
}
