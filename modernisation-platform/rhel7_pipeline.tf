resource "aws_imagebuilder_image_pipeline" "rhel7" {

  image_recipe_arn                 = aws_imagebuilder_image_recipe.rhel7.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.rhel7.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.rhel7.arn

  name = local.rhel_pipeline.pipeline.name

  schedule {
    schedule_expression                = local.rhel_pipeline.pipeline.schedule
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

}


/* This is being commented for reference, it is not necessary to deploy this and it takes a long time to apply.
resource "aws_imagebuilder_image" "rhel7" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.rhel7.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.rhel7.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.rhel7.arn
}
*/


resource "aws_imagebuilder_image_recipe" "rhel7" {
  block_device_mapping {
    device_name = local.rhel_pipeline.recipe.device_name

    ebs {
      delete_on_termination = local.rhel_pipeline.recipe.ebs.delete_on_termination
      volume_size           = local.rhel_pipeline.recipe.ebs.volume_size
      volume_type           = local.rhel_pipeline.recipe.ebs.volume_type
      encrypted             = local.rhel_pipeline.recipe.ebs.encrypted
      kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
    }
  }

  dynamic "component" {
    for_each = toset(local.rhel_pipeline.components)
    content {
      component_arn = aws_imagebuilder_component.rhel7_components[component.key].arn
    }
  }

  dynamic "component" {
    for_each = toset(local.rhel_pipeline.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  name         = local.rhel_pipeline.recipe.name
  parent_image = local.rhel_pipeline.recipe.parent_image
  version      = local.rhel_pipeline.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "rhel7" {
  description                   = local.rhel_pipeline.infra_config.description
  instance_profile_name         = aws_iam_instance_profile.image_builder_profile.name
  instance_types                = local.rhel_pipeline.infra_config.instance_types
  name                          = local.rhel_pipeline.infra_config.name
  security_group_ids            = local.rhel_pipeline.infra_config.security_group_ids
  subnet_id                     = local.rhel_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.rhel_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = "mp"
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "rhel7_components" {
  for_each = { for file in local.rhel_pipeline.components : file => yamldecode(file("components/linux/${file}")) }

  data     = file("components/linux/${each.key}")
  name     = join("_", ["mp", trimsuffix(each.key, ".yml")])
  platform = yamldecode(file("components/linux/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/linux/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_imagebuilder_distribution_configuration" "rhel7" {
  name = local.rhel_pipeline.distribution.name

  distribution {
    region = local.rhel_pipeline.distribution.region

    ami_distribution_configuration {

      name = local.rhel_pipeline.distribution.ami_name

      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }
  }
}
