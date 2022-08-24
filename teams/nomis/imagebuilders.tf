module "imagebuilder" {
  source   = "./modules/imagebuilder"
  for_each = local.imagebuilders

  region                       = "eu-west-2"
  team_name                    = "nomis"
  name                         = each.key
  configuration_version        = each.value.configuration_version
  description                  = each.value.description
  tags                         = merge(local.tags, each.value.tags)
  kms_key_id                   = data.aws_kms_key.hmpps_ebs_encryption_cmk
  image_recipe                 = each.value.image_recipe
  infrastructure_configuration = each.value.infrastructure_configuration
  distribution_configuration   = each.value.distribution_configuration
  image_pipeline               = each.value.image_pipeline

  core_shared_services = {
    repo_tfstate            = data.terraform_remote_state.modernisation-platform-repo.outputs
    imagebuilder_mp_tfstate = data.terraform_remote_state.mp-imagebuilder.outputs
  }
}
