resource "aws_iam_instance_profile" "image_builder_profile" {
  name = "ImageBuilder"
  role = aws_iam_role.image_builder_role.name
}

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

  tags     = {}
  tags_all = {}
}

output image_builder_profile {
  value = aws_iam_instance_profile.image_builder_profile.name
}
