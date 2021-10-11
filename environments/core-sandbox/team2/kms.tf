resource "aws_kms_key" "image_builder_encryption" {
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.image_builder_encryption.json

}

resource "aws_kms_alias" "image_builder_encryption" {
  name          = "alias/image-builder-encryption"
  target_key_id = aws_kms_key.image_builder_encryption.id
}

data "aws_iam_policy_document" "image_builder_encryption" {

  # checkov:skip=CKV_AWS_109: "Key policy requires asterisk resource"
  # checkov:skip=CKV_AWS_111: "Key policy requires asterisk resource"

  statement {
    effect  = "Allow"
    actions = [
      "kms:*"
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = concat(local.root_users_with_state_access, [data.aws_caller_identity.current.account_id])
    }

  }

  statement {
    effect  = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:ReEncrypt*",
      "kms:CreateGrant",
      "kms:Decrypt"
    ]

    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "374269020027"
      ]
    }

  }

}
