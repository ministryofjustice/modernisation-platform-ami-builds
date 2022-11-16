locals {
  component_template_args = {
    ami            = join("_", [var.ami_name_prefix, var.ami_base_name])
    version        = var.configuration_version
    branch         = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
    python_version = "3.9.6"
  }
}

