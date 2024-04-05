locals {
  component_template_args = {
    ami     = join("_", [var.ami_name_prefix, var.ami_base_name])
    version = var.configuration_version
    branch  = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
  }

  components_common = [
    {
      name       = "python_3_6"
      version    = "0.0.4"
      parameters = []
      }, {
      name    = "ansible"
      version = "0.0.14" # set to last known working ansible component version
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name  = "Branch"
        value = "main" # replace main with corresponding ansible branch if you are testing
      }]
    }
  ]
}
