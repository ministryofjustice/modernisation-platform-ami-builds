resource "aws_imagebuilder_image_pipeline" "TestPipeline" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.TestRecipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.TestInfraConfig.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.TestDistributionConfig.arn
  name                             = local.pipeline.name

  schedule {
    schedule_expression = local.pipeline.schedule
  }

  depends_on = [
    aws_imagebuilder_image_recipe.TestRecipe
  ]
}

/* This is being commented for reference, it is not necessary to deploy this and it takes a long time to apply.
resource "aws_imagebuilder_image" "TestImage" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.TestDistributionConfig.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.TestRecipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.TestInfraConfig.arn
}
*/


resource "aws_imagebuilder_image_recipe" "TestRecipe" {
  block_device_mapping {
    device_name = local.recipe.device_name

    ebs {
      delete_on_termination = local.recipe.ebs.delete_on_termination
      volume_size           = local.recipe.ebs.volume_size
      volume_type           = local.recipe.ebs.volume_type
      encrypted             = local.recipe.ebs.encrypted
      kms_key_id            = aws_kms_key.image_builder_encryption.arn
    }
  }

  dynamic "component" {
    for_each = local.component_map
    content {
      component_arn = aws_imagebuilder_component.TestComponent[component.key].arn
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  name         = local.recipe.name
  parent_image = local.recipe.parent_image
  version      = local.recipe.version
}

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

resource "aws_imagebuilder_infrastructure_configuration" "TestInfraConfig" {
  description                   = local.infra_config.description
  instance_profile_name         = aws_iam_instance_profile.image_builder_profile.name
  instance_types                = local.infra_config.instance_types
  name                          = local.infra_config.name
  security_group_ids            = local.infra_config.security_group_ids
  subnet_id                     = local.infra_config.subnet_id
  terminate_instance_on_failure = local.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = module.ImageBuilderLogsBucket.bucket.id
      s3_key_prefix  = "logs"
    }
  }
}

resource "aws_imagebuilder_component" "TestComponent" {
  for_each = local.component_map

  data = file("components/${each.key}.yml")
  name     = each.key
  platform = "Linux"
  version  = each.value

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_imagebuilder_distribution_configuration" "TestDistributionConfig" {
  name = local.distribution.name

  distribution {
    region = local.distribution.region

    ami_distribution_configuration {

        name = local.distribution.ami_name

        launch_permission {
          user_ids = local.ami_share_accounts
        }
    }
  }
}
