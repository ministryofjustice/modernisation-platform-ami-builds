locals {

  components_common = [
    {
      name    = "ansible"
      version = "0.0.6"
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name  = "Branch"
        value = "nit676-add-delius-core-oracle-db-config" # Custom branch added for testing, was: var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
      }]
    }
  ]

  component_template_args = {}

}