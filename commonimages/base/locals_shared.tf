locals {
  # these are all based on https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html#tags-you-should-use
  shared_tags = {
    business-unit = "HMPPS"
    application   = "n/a"
    branch        = var.BRANCH_NAME == "" ? "n/a" : var.BRANCH_NAME
    is-production = var.BRANCH_NAME == "main" ? "true" : "false"
    source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/commonimages/base/${var.ami_base_name}"
  }

  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

}
