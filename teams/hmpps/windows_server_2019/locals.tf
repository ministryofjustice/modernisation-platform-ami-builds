locals {
  components_common = [
    {
      name       = "powershell_core"
      version    = "1.0.0"
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
    },
    {
      name       = "git_windows"
      version    = "0.0.2"
      parameters = []
    }
  ]

  component_template_args = {}
}
