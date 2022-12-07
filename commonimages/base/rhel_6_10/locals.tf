locals {
  component_template_args = {
    ami     = join("_", [var.ami_name_prefix, var.ami_base_name])
    version = var.configuration_version
    branch  = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
  }

  components_common = [
    {
      name = "yum_packages"
      parameters = [{
        name  = "Packages"
        value = "wget curl unzip git nc ca-certificates gcc screen zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel xz-devel expat-devel musl-devel libffi-devel xz"
      }]
      }, {
      name       = "python_3_6"
      parameters = []
      }, {
      name = "ansible"
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name  = "Branch"
        value = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
      }]
    }
  ]
}
