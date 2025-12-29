locals {
  component_template_args = {}

  components_common = [
    {
      name    = "ansible"
      version = "0.0.11"
      parameters = [{
        name  = "Ami"
        value = "base_rhel_8_5_arm64"
        }, {
        name  = "Branch"
        value = "main" # replace main with corresponding ansible branch if you are testing
      }]
    }
  ]
}
