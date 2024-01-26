locals {
  components_common = [
    {
      name       = "chocolatey"
      version    = "0.0.1"
      parameters = []
    },
    {
      name       = "powershell_core"
      version    = "0.4.0"
      parameters = []
    },
    {
      name       = "aws_cli"
      version    = "0.0.4"
      parameters = []
    },
  ]

  component_template_args = {}
}
