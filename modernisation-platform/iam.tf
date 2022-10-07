resource "aws_iam_instance_profile" "image_builder_profile" {
  name = "ImageBuilder"
  role = aws_iam_role.image_builder_role.name
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role" "image_builder_role" {
  path                 = "/"
  name                 = "ImageBuilder"
  description          = "Allows EC2 instances to call AWS services on your behalf."
  max_session_duration = 3600

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }
      ]
      Version = "2012-10-17"
    }
  )

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder",
    "arn:aws:iam::aws:policy/AmazonInspectorFullAccess"
  ]

  inline_policy {
    name = "ImageBuilderS3BucketAccess"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "s3:PutObject",
              "s3:GetObject",
              "s3:ListBucket",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:s3:::ec2-image-builder-*/*",
            ]
          },
          {
            "Action" : [
              "ec2: ModifyImageAttribute",
            ],
            "Effect" : "Allow",
            "Resource" : [
              "arn:aws:ec2:eu-west-2::image/*"
            ]
          }
        ]
        Version = "2012-10-17"
      }
    )
  }

  inline_policy {
    name = "ImageBuilderInspectorComponentPrereqs"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "ssm:SendCommand",
              "ec2:CreateTags",
            ]
            Effect = "Allow"
            Resource = [
              "*",
            ]
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
  inline_policy {
    name = "ImageBuilderSessionManagerDocsPrereqs"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "ssm:ListDocuments",
              "ssm:ListDocumentVersions",
              "ssm:DescribeInstanceInformation",
              "ssm:DescribeDocumentParameters",
              "ssm:DescribeInstanceProperties",
              "ssm:CancelCommand",
              "ssm:ListCommands",
              "ssm:ListCommandInvocations",
              "ec2:DescribeInstanceStatus",
              "ssm:StartAutomationExecution",
              "ssm:DescribeAutomationExecutions",


            ]
            Effect = "Allow"
            Resource = [
              "*",
            ]
          },
        ]
        Version = "2012-10-17"
      }
    )
  }

  tags     = {}
  tags_all = {}
}

output "image_builder_profile" {
  value = aws_iam_instance_profile.image_builder_profile.name
}
