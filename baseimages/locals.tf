locals {
  ami_base_name = regex("/baseimages/(.+)", path.cwd)[0]
  region        = "eu-west-2"

  # these are all based on https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html#tags-you-should-use
  shared_tags = {
    business-unit = "HMPPS"
    application   = upper(local.team_name)
    branch        = var.BRANCH_NAME == "" ? "n/a" : var.BRANCH_NAME
    github-actor  = var.GH_ACTOR_NAME == "" ? "n/a" : var.GH_ACTOR_NAME
    is-production = var.BRANCH_NAME == "main" ? "true" : "false"
    owner         = "digital-studio-operations-team@digital.justice.gov.uk"
    source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/baseimages/${ami_base_name}"
  }

  # Different distribution config is allowed based on the github branch
  # triggering the pipeline
  accounts_to_distribute_ami = try(
    var.accounts_to_distribute_ami_by_branch[var.BRANCH_NAME],
    var.accounts_to_distribute_ami_by_branch["default"]
  )

  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)
}