locals {

  components_common = [
    {
      name    = "ansible"
      version = "0.0.5"
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name = "Branch"
        # value = "main" # replace main with corresponding ansible branch if you are testing
        value = "nomis/DSOS-1817/oracle-11g-ami-update"
      }]
    }
  ]

  component_template_args = {}

}
