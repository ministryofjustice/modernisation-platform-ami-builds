resource "aws_imagebuilder_image_pipeline" "Team2-Windows" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.Team2-Windows.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.Team2-Windows.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.Team2-Windows.arn
  name                             = local.windows_pipeline.pipeline.name

  schedule {
    schedule_expression = local.windows_pipeline.pipeline.schedule
  }

  depends_on = [
    aws_imagebuilder_image_recipe.Team2-Windows
  ]
}


/* This is being commented for reference, it is not necessary to deploy this and it takes a long time to apply.
resource "aws_imagebuilder_image" "Team2-Windows" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.Team2-Windows.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.Team2-Windows.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.Team2-Windows.arn
}
*/


resource "aws_imagebuilder_image_recipe" "Team2-Windows" {
  block_device_mapping {
    device_name = local.windows_pipeline.recipe.device_name

    ebs {
      delete_on_termination = local.windows_pipeline.recipe.ebs.delete_on_termination
      volume_size           = local.windows_pipeline.recipe.ebs.volume_size
      volume_type           = local.windows_pipeline.recipe.ebs.volume_type
      encrypted             = local.windows_pipeline.recipe.ebs.encrypted
      kms_key_id            = aws_kms_key.image_builder_encryption.arn
    }
  }

  dynamic "component" {
    for_each = { for file in local.windows_pipeline.components : file => file }
    content {
      component_arn = aws_imagebuilder_component.Team2-Windows-Components[component.key].arn
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  name         = local.windows_pipeline.recipe.name
  parent_image = local.windows_pipeline.recipe.parent_image
  version      = local.windows_pipeline.recipe.version
}

resource "aws_imagebuilder_infrastructure_configuration" "Team2-Windows" {
  description                   = local.windows_pipeline.infra_config.description
  instance_profile_name         = aws_iam_instance_profile.image_builder_profile.name
  instance_types                = local.windows_pipeline.infra_config.instance_types
  name                          = local.windows_pipeline.infra_config.name
  security_group_ids            = local.windows_pipeline.infra_config.security_group_ids
  subnet_id                     = local.windows_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.windows_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = module.ImageBuilderLogsBucket.bucket.id
      s3_key_prefix  = "logs"
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "Team2-Windows-Components" {
  for_each = { for file in local.windows_pipeline.components : file => yamldecode(file("components/Windows/${file}")) }

  data     = file("components/Windows/${each.key}")
  name     = trimsuffix(each.key, ".yml")
  platform = yamldecode(file("components/Windows/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/Windows/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}


// create each component in the base component directory
resource "aws_imagebuilder_component" "Team2-Windows-BaseComponents" {
  for_each = { for file in fileset(local.base_component_dir, "*") : file => yamldecode(file("${local.base_component_dir}/Windows/${file}")) }

  data     = file("${local.base_component_dir}/Windows/${each.key}")
  name     = trimsuffix(each.key, ".yml")
  platform = yamldecode(file("${local.base_component_dir}/Windows/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("${local.base_component_dir}/Windows/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_imagebuilder_distribution_configuration" "Team2-Windows" {
  name = local.windows_pipeline.distribution.name

  distribution {
    region = local.windows_pipeline.distribution.region

    ami_distribution_configuration {

      name = local.windows_pipeline.distribution.ami_name

      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }
  }
}
