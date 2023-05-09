locals {
  component_template_args = {}

  components_common = [
    {
      name    = "ansible"
      version = "0.0.6"
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name  = "Branch"
        value = "nit646-add-base-oracle-linux-ansible" # replace main with corresponding ansible branch if you are testing
      }]
    }
  ]
}
