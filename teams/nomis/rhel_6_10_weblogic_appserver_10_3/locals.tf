locals {
  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

  team_name        = "nomis"
  application_name = "core-shared-services"
  environment      = trimprefix(terraform.workspace, "core-shared-services-")
  provider_name    = "core-vpc-development"

  # these are all based on https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html#tags-you-should-use
  shared_tags = {
    business-unit = "HMPPS"
    application   = upper(local.team_name)
    branch        = var.BRANCH_NAME == "" ? "n/a" : var.BRANCH_NAME
    github-actor  = var.GH_ACTOR_NAME == "" ? "n/a" : var.GH_ACTOR_NAME
    is-production = var.BRANCH_NAME == "main" ? "true" : "false"
    owner         = "DSO: digital-studio-operations-team@digital.justice.gov.uk"
    source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/teams/nomis"
  }

  components_common = [
    {
      name    = "ansible"
      version = "0.0.2"
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name  = "Branch"
        value = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
      }]
    }
  ]

  component_template_args = {}

  # Different distribution config is allowed based on the github branch
  # triggering the pipeline
  launch_permission_account_names = try(
    var.launch_permission_accounts_by_branch[var.BRANCH_NAME],
    var.launch_permission_accounts_by_branch["default"]
  )
}