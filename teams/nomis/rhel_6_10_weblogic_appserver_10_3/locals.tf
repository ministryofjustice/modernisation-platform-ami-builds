locals {

  components_common = [
    {
      name    = "ansible"
      version = "0.0.9"
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name  = "Branch"
        value = "dso-2239/ansible-failure-handling-in-ami-builds" # replace main with corresponding ansible branch if you are testing
      }]
    }
  ]

  component_template_args = {}
}
