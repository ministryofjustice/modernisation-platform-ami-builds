locals {
  # NOTE: do not include branch name here as only underscore and alphanumeric allowed
  ami_name = join("_", flatten([
    var.ami_base_name,
    var.release_or_patch == "" ? [] : [var.release_or_patch],
    "{{ imagebuilder:buildDate }}"
  ]))

  core_shared_services = {
    repo_tfstate            = data.terraform_remote_state.core_shared_services_production.outputs
    imagebuilder_mp_tfstate = data.terraform_remote_state.imagebuilder_mp.outputs
  }

  component_template_args = {
    ami     = var.ami_base_name
    version = var.configuration_version
    branch  = var.branch == "" ? "main" : var.branch
  }

  components_custom_data = {
    for component_filename in var.components_custom :
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
    for component_aws in var.components_aws :
    "${component_aws}-version" => data.aws_imagebuilder_component.this[component_aws].version
  }

  component_version_tags = merge(local.components_custom_versions, local.components_aws_versions)

  default_tags = {
    image-pipeline               = var.ami_base_name
    image-recipe                 = join("/", [var.ami_base_name, var.configuration_version])
    infrastructure-configuration = join("/", [var.ami_base_name, var.configuration_version])
    release-or-patch             = var.release_or_patch == "" ? "n/a" : var.release_or_patch
  }

  tags = merge(
    local.default_tags,
    local.component_version_tags,
    var.tags
  )

  ami_tags = merge(local.tags, {
    Name = local.ami_name
  })
}
