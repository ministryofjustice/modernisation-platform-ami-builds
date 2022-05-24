resource "aws_imagebuilder_image_pipeline" "windowsserver2022" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.windowsserver2022.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.windowsserver2022.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.windowsserver2022.arn
  name                             = local.windows_pipeline.pipeline.name

  schedule {
    schedule_expression                = local.windows_pipeline.pipeline.schedule
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

}


/* This is being commented for reference, it is not necessary to deploy this and it takes a long time to apply.
resource "aws_imagebuilder_image" "windowsserver2022" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.windowsserver2022.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.windowsserver2022.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.windowsserver2022.arn
}
*/


resource "aws_imagebuilder_image_recipe" "windowsserver2022" {
  block_device_mapping {
    device_name = local.windows_pipeline.recipe.device_name

    ebs {
      delete_on_termination = local.windows_pipeline.recipe.ebs.delete_on_termination
      volume_size           = local.windows_pipeline.recipe.ebs.volume_size
      volume_type           = local.windows_pipeline.recipe.ebs.volume_type
      encrypted             = local.windows_pipeline.recipe.ebs.encrypted
      kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
    }
  }

  dynamic "component" {
    for_each = toset(local.windows_pipeline.components)
    content {
      component_arn = aws_imagebuilder_component.windowsserver2022_components[component.key].arn
    }
  }

  dynamic "component" {
    for_each = toset(local.windows_pipeline.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  name         = local.windows_pipeline.recipe.name
  parent_image = local.windows_pipeline.recipe.parent_image
  version      = local.windows_pipeline.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "windowsserver2022" {
  description                   = local.windows_pipeline.infra_config.description
  instance_profile_name         = data.terraform_remote_state.mp-imagebuilder.outputs.image_builder_profile
  instance_types                = local.windows_pipeline.infra_config.instance_types
  name                          = local.windows_pipeline.infra_config.name
  security_group_ids            = local.windows_pipeline.infra_config.security_group_ids
  subnet_id                     = local.windows_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.windows_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = local.team_name
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "windowsserver2022_components" {
  for_each = { for file in local.windows_pipeline.components : file => yamldecode(file("components/windows/${file}")) }

  data     = file("components/windows/${each.key}")
  name     = join("_", [local.team_name, trimsuffix(each.key, ".yml")])
  kms_key_id = data.aws_kms_key.ebs_encryption_cmk.arn
  platform = yamldecode(file("components/windows/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/windows/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_imagebuilder_distribution_configuration" "windowsserver2022" {
  name = local.windows_pipeline.distribution.name
  kms_key_id = data.aws_kms_key.ebs_encryption_cmk.arn

  distribution {
    region = local.windows_pipeline.distribution.region

    ami_distribution_configuration {

      name = local.windows_pipeline.distribution.ami_name
      kms_key_id = data.aws_kms_key.ebs_encryption_cmk.arn

      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }
  }
}
