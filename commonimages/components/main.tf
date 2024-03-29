resource "aws_imagebuilder_component" "this" {
  for_each = local.components_yaml

  name        = each.value.yaml.name
  description = each.value.yaml.description
  platform    = each.value.yaml.parameters[1].Platform.default
  version     = each.value.yaml.parameters[0].Version.default
  data        = each.value.raw
  kms_key_id  = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
  tags        = local.tags

  lifecycle {
    create_before_destroy = true
  }
}