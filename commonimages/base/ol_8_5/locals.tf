locals {
  component_template_args = {}

  components_common = [
    {
      name       = "python_3_9"
      version    = "0.0.3"
      parameters = []
    }
    #  ,{
    #     name    = "ansible"
    #     version = "0.0.5"
    #     parameters = [{
    #       name  = "Ami"
    #       value = join("_", [var.ami_name_prefix, var.ami_base_name])
    #       }, {
    #       name  = "Branch"
    #       value = "main" # replace main with corresponding ansible branch if you are testing
    #     }]
    #   }
  ]
}
