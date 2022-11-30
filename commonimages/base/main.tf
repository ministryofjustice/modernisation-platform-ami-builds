module "imagebuilder" {
  source = "./../modulestest2//imagebuilder"

  region                          = var.region
  team_name                       = var.ami_name_prefix # would be best to rename team_name -> ami_name_prefix for all, leave for later PR
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
