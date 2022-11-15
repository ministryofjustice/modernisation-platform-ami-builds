locals {
  component_template_args = {
    ami            = var.ami_name_prefix
    version        = var.configuration_version
    branch         = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
    python_version = "3.9.6"
  }
}

