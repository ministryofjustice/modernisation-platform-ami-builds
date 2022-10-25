module "imagebuilder" {
  source   = "..//modules/imagebuilder"
  for_each = var.imagebuilders

  region                       = "eu-west-2"
  team_name                    = "oasys"
  name                         = each.key
  configuration_version        = each.value.configuration_version
  description                  = each.value.description
  release_or_patch             = lookup(each.value, "release_or_patch", "")
  tags                         = merge(local.tags, each.value.tags)
  kms_key_id                   = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
  account_ids_lookup           = local.environment_management.account_ids
  image_recipe                 = each.value.image_recipe
  infrastructure_configuration = each.value.infrastructure_configuration
  distribution_configuration   = local.distribution_configuration
  image_pipeline               = each.value.image_pipeline
  branch                       = var.BRANCH_NAME
  gh_actor                     = var.GH_ACTOR_NAME
}
