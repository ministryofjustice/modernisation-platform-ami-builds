resource "aws_imagebuilder_image_pipeline" "windows_s3_test" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.windows_s3_test.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.windows_s3_test.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.windows_s3_test.arn
  name                             = local.windows_s3_test.pipeline.name

  schedule {
    # schedule_expression                = local.windows_s3_test.pipeline.schedule
    # pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

}


/* This is being commented for reference, it is not necessary to deploy this and it takes a long time to apply.
resource "aws_imagebuilder_image" "windows_s3_test" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.windows_s3_test.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.windows_s3_test.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.windows_s3_test.arn
}
*/


resource "aws_imagebuilder_image_recipe" "windows_s3_test" {
  block_device_mapping {
    device_name = local.windows_s3_test.recipe.device_name

    ebs {
      delete_on_termination = local.windows_s3_test.recipe.ebs.delete_on_termination
      volume_size           = local.windows_s3_test.recipe.ebs.volume_size
      volume_type           = local.windows_s3_test.recipe.ebs.volume_type
      encrypted             = local.windows_s3_test.recipe.ebs.encrypted
      kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
    }
  }

  dynamic "component" {
    for_each = toset(local.windows_s3_test.components)
    content {
      component_arn = aws_imagebuilder_component.windows_s3_test_components[component.value.document].arn
      dynamic "parameter" {
        for_each = { for param_key, param_value in component.value.parameters : param_key => param_value if component.value.parameters != {} }
        content {
          name  = parameter.key
          value = parameter.value
        }
      }
    }
  }

  dynamic "component" {
    for_each = toset(local.windows_s3_test.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  name         = local.windows_s3_test.recipe.name
  parent_image = local.windows_s3_test.recipe.parent_image
  version      = local.windows_s3_test.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "windows_s3_test" {
  description                   = local.windows_s3_test.infra_config.description
  instance_profile_name         = data.terraform_remote_state.mp-imagebuilder.outputs.image_builder_profile
  instance_types                = local.windows_s3_test.infra_config.instance_types
  name                          = local.windows_s3_test.infra_config.name
  security_group_ids            = local.windows_s3_test.infra_config.security_group_ids
  subnet_id                     = local.windows_s3_test.infra_config.subnet_id
  terminate_instance_on_failure = local.windows_s3_test.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = "mp"
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "windows_s3_test_components" {
  for_each = { for component in local.windows_s3_test.components : component.document => component.parameters }

  data     = file("components/windows/${each.key}")
  name     = join("_", ["example", trimsuffix(each.key, ".yml")])
  platform = yamldecode(file("components/windows/${each.key}")).parameters[1].Platform.default
  version  = each.value.Version

  kms_key_id = data.aws_kms_key.ebs_encryption_cmk.arn

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_imagebuilder_distribution_configuration" "windows_s3_test" {
  name = local.windows_s3_test.distribution.name

  distribution {
    region = local.windows_s3_test.distribution.region

    ami_distribution_configuration {

      name       = local.windows_s3_test.distribution.ami_name
      kms_key_id = data.aws_kms_key.ebs_encryption_cmk.arn

      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }
  }
}
