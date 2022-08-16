locals {
  config = yamldecode(file("./${path.root}/components/${var.component_filename}"))["parameters"]
  params = flatten([
    for d, value in local.config : [
        for v, item in value : {
           "${replace((replace(v, "Version", "${var.component_filename}-component-version")), ".yml", "")}" = item.default
        }
    ]
  ])

  map = { for a in local.params: 
    keys(a)[0] => values(a)[0]
  }
}