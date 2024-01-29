locals {
  components_common = [
    {
      name       = "powershell_core"
      version    = "0.6.0"
      parameters = []
    },
    {
      name       = "aws_cli"
      version    = "0.0.4"
      parameters = []
    },
    {
      name       = "psreadline_fix"
      version    = "0.0.4"
      parameters = []
    }
  ]

  component_template_args = {}
}
