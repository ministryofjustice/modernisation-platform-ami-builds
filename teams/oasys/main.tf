module "imagebuilder" {
  source = "..//modules/imagebuilder"

  region                       = local.region
  team_name                    = local.team_name
  ami_base_name                = var.ami_base_name
  configuration_version        = var.configuration_version
  description                  = var.description
  release_or_patch             = lookup(each.value, "release_or_patch", "")
  tags                         = merge(local.tags, each.value.tags)
  kms_key_id                   = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
  account_ids_lookup           = local.environment_management.account_ids
  image_recipe                 = var.image_recipe
  infrastructure_configuration = var.infrastructure_configuration
  accounts_to_distribute_ami   = local.accounts_to_distribute_ami
  launch_template_exists       = var.launch_template_exists
  image_pipeline               = each.value.image_pipeline
  branch                       = var.BRANCH_NAME
  gh_actor                     = var.GH_ACTOR_NAME
}
