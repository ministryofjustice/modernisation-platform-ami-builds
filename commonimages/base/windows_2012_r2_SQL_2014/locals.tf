locals {
  components_common = [
    {
      name       = "chocolatey"
      version    = "0.0.4"
      parameters = []
    },
    {
      name       = "powershell_core_server_2012"
      version    = "0.0.3"
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
