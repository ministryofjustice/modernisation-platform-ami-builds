# Retrieve KMS key for AMI/snapshot encryption
# data "aws_kms_key" "ebs_encryption_cmk" {
#   key_id = "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/ebs-hmpps"
# }

data "aws_kms_key" "ebs_encryption_cmk" {
  key_id = "arn:aws:kms:eu-west-2:${local.environment_management.account_ids["nomis-test"]}:alias/nomis-image-builder"
}

data "aws_launch_template" "weblogic-launch-templates" {
    provider = aws.nomis-test
    filter {
        name = "tag:environment-name"
        values = ["nomis-test"]
    }
}

data "aws_ami" "weblogic" {
  most_recent = true
  owners      = [local.environment_management.account_ids["core-shared-services-production"]]

  filter {
    name   = "name"
    values = ["nomis_Weblogic_2022-05-10T12*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_snapshot_create_volume_permission" "volume-launch-permissions" {

    for_each = {for bd in data.aws_ami.weblogic.block_device_mappings: bd.device_name => bd}
    account_id = local.environment_management.account_ids["nomis-test"]
    snapshot_id = each.value.ebs.snapshot_id
}