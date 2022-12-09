module "imagebuilder" {
  source   = "..//modules/imagebuilder"

  # region                       = "eu-west-2"
  # team_name                    = "nomis"
  name                         = each.key
  configuration_version        = each.value.configuration_version
  description                  = each.value.description
  release_or_patch             = var.BRANCH_NAME != "main" ? "test" : lookup(each.value, "release_or_patch", "")
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

module "imagebuilder" {
  source = "./../../modules//imagebuilder"

  region                          = var.region
  team_name                       = var.ami_name_prefix # would be best to rename team_name -> ami_name_prefix for all, leave for later PR
  account_id                      = data.aws_caller_identity.current.account_id
  ami_base_name                   = var.ami_base_name
  configuration_version           = var.configuration_version
  description                     = var.description
  release_or_patch                = var.BRANCH_NAME != "main" ? "test" : var.release_or_patch
  tags                            = merge(local.shared_tags, var.tags)
  kms_key_id                      = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
  account_ids_lookup              = local.environment_management.account_ids
  parent_image                    = var.parent_image
  block_device_mappings_ebs       = var.block_device_mappings_ebs
  components_aws                  = var.components_aws
  components_common               = local.components_common
  components_custom               = var.components_custom
  component_template_args         = local.component_template_args
  user_data                       = var.user_data
  infrastructure_configuration    = var.infrastructure_configuration
  account_to_distribute_ami       = var.account_to_distribute_ami
  launch_permission_account_names = var.launch_permission_account_names
  launch_template_exists          = var.launch_template_exists
  image_pipeline                  = var.image_pipeline
  systems_manager_agent           = var.systems_manager_agent
  branch                          = var.BRANCH_NAME
  gh_actor                        = var.GH_ACTOR_NAME
}



output "parent_ami" {
  value       = { for key, value in module.imagebuilder : key => value.parent_ami }
  description = "parent AMI details"
}
