locals {
  component_template_args = {
    ami            = join("_", [var.ami_name_prefix, var.ami_base_name])
    branch         = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
    python_version = "3.9.6"
  }

  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

  components_data = {
    for component_filename in fileset("templates", "*") :
    component_filename => length(regexall(".*tftpl", component_filename)) > 0 ?
    templatefile(component_filename, var.component_template_args) :
    file(component_filename)
  }

  components_yaml = {
    for component_filename, data in local.components_data :
    component_filename => {
      raw  = data
      yaml = yamldecode(data)
    }
  }

}