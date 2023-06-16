locals {
  component_template_args = {}

  components_common = [
    {
      name    = "ansible"
      version = "0.0.6"
      parameters = [ {
        name  = "Branch"
        value = "development" # replace main with corresponding ansible branch if you are testing
      }]
    }
  ]
}
