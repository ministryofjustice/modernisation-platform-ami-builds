# Retrieve KMS key for AMI/snapshot encryption
data "aws_kms_key" "sprinkler_ebs_encryption_key" {
  key_id = "arn:aws:kms:eu-west-2:${local.environment_management.account_ids["sprinkler-development"]}:alias/sprinkler_ebs-encryption-key"
}