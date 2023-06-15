locals {

  components_common = [
    {
      name    = "ansible"
      version = "0.0.6"
      parameters = [{
        name  = "Ami"
        value = join("_", [var.ami_name_prefix, var.ami_base_name])
        }, {
        name  = "Branch"
        value = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
        }, {
        name  = "AnsibleTags"
        value = "amibuild,oracle_19c_download"
      }]
    }
  ]

  component_template_args = {}

}
