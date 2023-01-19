locals {
  components_common = [
    {
      name       = "prometheus_windows_exporter"
      version    = "1.1.7"
      parameters = []
    },
    {
      name       = "powershell_core"
      version    = "0.1.9"
      parameters = []
    },
  ]

  component_template_args = {}
}