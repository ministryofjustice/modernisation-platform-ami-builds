# Retrieve KMS key for AMI/snapshot encryption
# data "aws_kms_key" "ebs_encryption_cmk" {
#   key_id = "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/ebs-hmpps"
# }

data "aws_kms_key" "ebs_encryption_cmk" {
  key_id = "arn:aws:kms:eu-west-2:${local.environment_management.account_ids["nomis-test"]}:alias/nomis-image-builder"
}