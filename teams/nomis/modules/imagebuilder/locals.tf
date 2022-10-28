locals {
  name             = "${var.team_name}_${var.name}"
  name_and_version = replace("${local.name}_${var.configuration_version}", ".", "_")

  core_shared_services = {
    repo_tfstate            = data.terraform_remote_state.core_shared_services_production.outputs
    imagebuilder_mp_tfstate = data.terraform_remote_state.imagebuilder_mp.outputs
  }

  component_template_args = {
    ami     = local.name
    version = var.configuration_version
    branch  = var.branch == "" ? "main" : var.branch
  }

  components_custom_data = {
    for component_filename in var.image_recipe.components_custom :
    component_filename => length(regexall(".*tftpl", component_filename)) > 0 ?
    templatefile(component_filename, local.component_template_args) :
    file(component_filename)
  }

  components_custom_yaml = {
    for component_filename, data in local.components_custom_data :
    component_filename => {
      raw  = data
      yaml = yamldecode(data)
    }
  }

  components_custom_versions = {
    for component_filename, data in local.components_custom_yaml :
    "${data.yaml.name}-version" => data.yaml.parameters[0].Version.default
  }

  components_aws_versions = {
    for component_aws in var.image_recipe.components_aws :
    "${component_aws}-version" => data.aws_imagebuilder_component.this[component_aws].version
  }

  component_version_tags = merge(local.components_custom_versions, local.components_aws_versions)

  default_tags = {
    image-pipeline               = local.name
    image-recipe                 = join("/", [local.name, var.configuration_version])
    infrastructure-configuration = join("/", [local.name, var.configuration_version])
    release-or-patch             = var.release_or_patch == "" ? "n/a" : var.release_or_patch
  }

  tags = merge(
    local.default_tags,
    local.component_version_tags,
    var.tags
  )

  # NOTE: do not include branch name here as only underscore and alphanumeric allowed
  ami_name = join("_", flatten([
    local.name,
    var.release_or_patch == "" ? [] : [var.release_or_patch],
    "{{ imagebuilder:buildDate }}"
  ]))

  ami_tags = merge(local.tags, {
    Name = local.ami_name
  })

  ami_parent_id  = try(var.account_ids_lookup[var.image_recipe.parent_image.owner], var.image_recipe.parent_image.owner)
  ami_parent_arn = try("arn:aws:imagebuilder:${var.region}:${local.ami_parent_id}:image/${var.image_recipe.parent_image.arn_resource_id}", null)
}

