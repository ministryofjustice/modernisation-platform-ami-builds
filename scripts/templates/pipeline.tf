resource "aws_imagebuilder_image_pipeline" "#SUFFIX#" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.#SUFFIX#.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.#SUFFIX#.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.#SUFFIX#.arn
  name                             = local.#SUFFIX#_pipeline.pipeline.name

  schedule {
    schedule_expression                = local.#SUFFIX#_pipeline.pipeline.schedule
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

  depends_on = [
    aws_imagebuilder_image_recipe.#SUFFIX#
  ]
}


/* This is being commented for reference, it is not necessary to deploy this and it takes a long time to apply.
resource "aws_imagebuilder_image" "#SUFFIX#" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.#SUFFIX#.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.#SUFFIX#.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.#SUFFIX#.arn
}
*/


resource "aws_imagebuilder_image_recipe" "#SUFFIX#" {
  block_device_mapping {
    device_name = local.#SUFFIX#_pipeline.recipe.device_name

    ebs {
      delete_on_termination = local.#SUFFIX#_pipeline.recipe.ebs.delete_on_termination
      volume_size           = local.#SUFFIX#_pipeline.recipe.ebs.volume_size
      volume_type           = local.#SUFFIX#_pipeline.recipe.ebs.volume_type
      encrypted             = local.#SUFFIX#_pipeline.recipe.ebs.encrypted
      kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
    }
  }

  dynamic "component" {
    for_each = { for file in local.#SUFFIX#_pipeline.components : file => file }
    content {
      component_arn = aws_imagebuilder_component.#SUFFIX#_components[component.key].arn
    }
  }

  dynamic "component" {
    for_each = toset(local.#SUFFIX#_pipeline.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  name         = local.#SUFFIX#_pipeline.recipe.name
  parent_image = local.#SUFFIX#_pipeline.recipe.parent_image
  version      = local.#SUFFIX#_pipeline.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "#SUFFIX#" {
  description                   = local.#SUFFIX#_pipeline.infra_config.description
  instance_profile_name         = data.terraform_remote_state.mp-imagebuilder.outputs.image_builder_profile
  instance_types                = local.#SUFFIX#_pipeline.infra_config.instance_types
  name                          = local.#SUFFIX#_pipeline.infra_config.name
  security_group_ids            = local.#SUFFIX#_pipeline.infra_config.security_group_ids
  subnet_id                     = local.#SUFFIX#_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.#SUFFIX#_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = local.team_name
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "#SUFFIX#_components" {
  for_each = { for file in local.#SUFFIX#_pipeline.components : file => yamldecode(file("components/#OS#/${file}")) }

  data     = file("components/#OS#/${each.key}")
  name     = join("_", [local.team_name, trimsuffix(each.key, ".yml")])
  platform = yamldecode(file("components/#OS#/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/#OS#/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_imagebuilder_distribution_configuration" "#SUFFIX#" {
  name = local.#SUFFIX#_pipeline.distribution.name

  distribution {
    region = local.#SUFFIX#_pipeline.distribution.region

    ami_distribution_configuration {

      name = local.#SUFFIX#_pipeline.distribution.ami_name
      kms_key_id = data.aws_kms_key.ebs_encryption_cmk.arn

      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }
  }
}
