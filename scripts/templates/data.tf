# Retrieve KMS key for AMI/snapshot encryption
data "aws_kms_key" "ebs_encryption_cmk" {
  key_id = "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/ebs-encryption-key" ## Edit this line to match key of choice
}
