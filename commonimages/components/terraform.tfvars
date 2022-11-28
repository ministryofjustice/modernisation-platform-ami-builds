# following are passed in via pipeline
# BRANCH_NAME =  
# GH_ACTOR_NAME = 

description           = "shared rhel 7.9 base image"
account_to_distribute_ami = "core-shared-services-production"
ami_base_name = "rhel_7_9"

tags = {
  owner         = "digital-studio-operations-team@digital.justice.gov.uk"
  business-unit = "HMPPS"
  application   = "n/a"
  branch        = var.BRANCH_NAME == "" ? "n/a" : var.BRANCH_NAME
  github-actor  = var.GH_ACTOR_NAME == "" ? "n/a" : var.GH_ACTOR_NAME
  is-production = var.BRANCH_NAME == "main" ? "true" : "false"
  source-code   = "https://github.com/ministryofjustice/modernisation-platform-ami-builds/tree/main/commonimages/components"
}


