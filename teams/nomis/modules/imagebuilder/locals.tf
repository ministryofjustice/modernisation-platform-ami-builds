locals {
  name             = "${var.team_name}_${var.name}"
  name_and_version = replace("${local.name}_${var.configuration_version}", ".", "_")

  core_shared_services = {
    repo_tfstate            = data.terraform_remote_state.core_shared_services_production.outputs
    imagebuilder_mp_tfstate = data.terraform_remote_state.imagebuilder_mp.outputs
  }

  component_template_args = {
    BRANCH_NAME = var.branch == "" ? "main" : var.branch
  }

  components_custom_yaml = {
    for component_filename in var.image_recipe.components_custom :
    component_filename => yamldecode(
      length(regexall(".*tmpl", component_filename)) > 0 ?
      templatefile("${component_filename}.tftpl", local.component_template_args) :
      file("${component_filename}.deliberateerror")
    )
  }

  components_custom_versions = {
    for component_filename, component_yaml in local.components_custom_yaml :
    "${component_yaml.name}-version" => component_yaml.parameters[0].Version.default
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
}

