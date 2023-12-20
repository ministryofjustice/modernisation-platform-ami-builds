locals {

  components_common = [
    {
      name    = "ansible"
      version = "0.0.11"
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name  = "Branch"
        value = "main" # replace main with corresponding ansible branch if you are testing
      }]
    }
  ]

  component_template_args = {
    ami     = join("_", [var.ami_name_prefix, var.ami_base_name])
    version = var.configuration_version
    branch  = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
  }
}
