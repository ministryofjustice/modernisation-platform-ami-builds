locals {
  components_common = [
    {
      name       = "powershell_core"
      version    = "0.3.0"
      parameters = []
    },
    {
      name       = "aws_cli"
      version    = "0.0.2"
      parameters = []
    },
  ]

  component_template_args = {}
}