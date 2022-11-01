module "imagebuilder" {
  source = "../../modules//imagebuilder"

  region                       = var.region
  team_name                    = local.team_name
  ami_base_name                = var.ami_base_name
  configuration_version        = var.configuration_version
  description                  = var.description
  release_or_patch             = try(each.value, "release_or_patch", "")
  tags                         = merge(local.shared_tags, var.tags)
  kms_key_id                   = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
  account_ids_lookup           = local.environment_management.account_ids
  parent_image                 = var.parent_image
  block_device_mappings_ebs    = var.block_device_mappings_ebs
  components_aws               = var.components_aws
  components_custom            = var.components_custom
  user_data                    = var.user_data
  infrastructure_configuration = var.infrastructure_configuration
  accounts_to_distribute_ami   = local.accounts_to_distribute_ami
  launch_template_exists       = var.launch_template_exists
  image_pipeline               = var.image_pipeline
  branch                       = var.BRANCH_NAME
  gh_actor                     = var.GH_ACTOR_NAME
}
