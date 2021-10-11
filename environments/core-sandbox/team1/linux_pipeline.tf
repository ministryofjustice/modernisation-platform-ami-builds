resource "aws_imagebuilder_image_pipeline" "Team1-Linux" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.Team1-Linux.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.Team1-Linux.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.Team1-Linux-DistributionConfig.arn
  name                             = local.linux_pipeline.pipeline.name

  schedule {
    schedule_expression = local.linux_pipeline.pipeline.schedule
  }

  depends_on = [
    aws_imagebuilder_image_recipe.Team1-Linux
  ]
}


/* This is being commented for reference, it is not necessary to deploy this and it takes a long time to apply.
resource "aws_imagebuilder_image" "Team1-Linux" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.Team1-Linux-DistributionConfig.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.Team1-Linux.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.Team1-Linux.arn
}
*/


resource "aws_imagebuilder_image_recipe" "Team1-Linux" {
  block_device_mapping {
    device_name = local.linux_pipeline.recipe.device_name

    ebs {
      delete_on_termination = local.linux_pipeline.recipe.ebs.delete_on_termination
      volume_size           = local.linux_pipeline.recipe.ebs.volume_size
      volume_type           = local.linux_pipeline.recipe.ebs.volume_type
      encrypted             = local.linux_pipeline.recipe.ebs.encrypted
      kms_key_id            = aws_kms_key.image_builder_encryption.arn
    }
  }

  dynamic "component" {
    for_each = { for file in local.linux_pipeline.components : file => file }
    content {
      component_arn = aws_imagebuilder_component.Team1-Linux-Components[component.key].arn
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  name         = local.linux_pipeline.recipe.name
  parent_image = local.linux_pipeline.recipe.parent_image
  version      = local.linux_pipeline.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "Team1-Linux" {
  description                   = local.linux_pipeline.infra_config.description
  instance_profile_name         = aws_iam_instance_profile.image_builder_profile.name
  instance_types                = local.linux_pipeline.infra_config.instance_types
  name                          = local.linux_pipeline.infra_config.name
  security_group_ids            = local.linux_pipeline.infra_config.security_group_ids
  subnet_id                     = local.linux_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.linux_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = module.ImageBuilderLogsBucket.bucket.id
      s3_key_prefix  = "logs"
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "Team1-Linux-Components" {
  for_each = { for file in local.linux_pipeline.components : file => yamldecode(file("components/linux/${file}")) }

  data     = file("components/linux/${each.key}")
  name     = trimsuffix(each.key, ".yml")
  platform = yamldecode(file("components/linux/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/linux/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}


// create each component in the base component directory
resource "aws_imagebuilder_component" "Team1-Linux-BaseComponents" {
  for_each = { for file in fileset(local.base_component_dir, "*") : file => yamldecode(file("${local.base_component_dir}/linux/${file}")) }

  data     = file("${local.base_component_dir}/linux/${each.key}")
  name     = trimsuffix(each.key, ".yml")
  platform = yamldecode(file("${local.base_component_dir}/linux/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("${local.base_component_dir}/linux/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_imagebuilder_distribution_configuration" "Team1-Linux-DistributionConfig" {
  name = local.linux_pipeline.distribution.name

  distribution {
    region = local.linux_pipeline.distribution.region

    ami_distribution_configuration {

      name = local.linux_pipeline.distribution.ami_name

      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }
  }
}
