locals {
  component_template_args = {}

  components_common = [
    {
      name = "yum_packages"
      parameters = [{
        name  = "Packages"
        value = "wget curl unzip git nc ca-certificates gcc screen zlib-devel bzip2-devel openssl-devel libffi-devel"
      }]
    }, {
      name       = "python_3_9"
      parameters = []
    }, {
      name       = "ansible"
      parameters = [{
        name = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
      }, {
        name = "Branch"
        value = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
      }]
    }
  ]
}
