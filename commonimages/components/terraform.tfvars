# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

account_to_distribute_ami = "core-shared-services-production"

tags = {
  owner         = "digital-studio-operations-team@digital.justice.gov.uk"
  business-unit = "HMPPS"
  application   = "n/a"
  branch        = var.BRANCH_NAME == "" ? "n/a" : var.BRANCH_NAME
  github-actor  = var.GH_ACTOR_NAME == "" ? "n/a" : var.GH_ACTOR_NAME
  is-production = var.BRANCH_NAME == "main" ? "true" : "false"
  source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/commonimages/components"
}