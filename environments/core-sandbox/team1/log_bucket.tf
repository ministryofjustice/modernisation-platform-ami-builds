module "ImageBuilderLogsBucket" {
  source = "github.com/ministryofjustice/modernisation-platform-terraform-s3-bucket?ref=v5.0.0"

  providers = {
    aws.bucket-replication = aws.bucket-replication
  }

  bucket_prefix       = "ec2-image-builder-logs-"
  versioning_enabled  = false
  replication_enabled = false

  tags = local.tags
}
