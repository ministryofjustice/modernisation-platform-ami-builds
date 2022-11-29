locals {
  component_template_args = {}

  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

  components_data = {
    for component_filename in fileset("templates", "*") :
    component_filename => length(regexall(".*tftpl", component_filename)) > 0 ?
    templatefile(component_filename, local.component_template_args) :
    file(component_filename)
  }

  components_yaml = {
    for component_filename, data in local.components_data :
    component_filename => {
      raw  = data
      yaml = yamldecode(replace(data, "!Ref ", "")) # stop yamldecode breaking from cloudformation specific syntax. Not trusted cf.
    }
  }

}