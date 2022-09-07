resource "aws_imagebuilder_image_pipeline" "jumpserver" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.jumpserver.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.jumpserver.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.jumpserver.arn
  name                             = local.jumpserver_pipeline.pipeline.name

  schedule {
    schedule_expression                = local.jumpserver_pipeline.pipeline.schedule
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

}

# resource "aws_imagebuilder_image" "jumpserver" {
#   image_recipe_arn                 = aws_imagebuilder_image_recipe.jumpserver.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.jumpserver.arn
#   distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.jumpserver.arn
#   image_tests_configuration {
#     image_tests_enabled = false
#   }
#   # TAGS NOT SUPPORTED FOR IMAGES
# }

# changing ebs mapping
resource "aws_imagebuilder_image_recipe" "jumpserver" {
  dynamic "block_device_mapping" {
    for_each = local.jumpserver_pipeline.recipe.ebs_block_device
    content {
      device_name = block_device_mapping.value.device_name
      ebs {
        delete_on_termination = lookup(block_device_mapping.value, "delete_on_termination", null)
        encrypted             = lookup(block_device_mapping.value, "encrypted", null)
        kms_key_id            = lookup(block_device_mapping.value, "kms_key_id", null)
        volume_size           = lookup(block_device_mapping.value, "volume_size", null)
        volume_type           = lookup(block_device_mapping.value, "volume_type", null)
        iops                  = lookup(block_device_mapping.value, "iops", null)
      }
    }
  }

  dynamic "component" {
    for_each = toset(local.jumpserver_pipeline.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }
  dynamic "component" {
    for_each = toset(local.jumpserver_pipeline.components)
    content {
      component_arn = aws_imagebuilder_component.jumpserver_components[component.key].arn
      dynamic "parameter"{
        for_each = component.value.parameters
        content {
          parameter {
            name = parameter.value.name
            value = parameter.value.value
          }
        }
      }
    }
  }


  lifecycle {
    create_before_destroy = true
  }

  name         = local.jumpserver_pipeline.recipe.name
  parent_image = local.jumpserver_pipeline.recipe.parent_image
  version      = local.jumpserver_pipeline.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "jumpserver" {
  description                   = local.jumpserver_pipeline.infra_config.description
  instance_profile_name         = data.terraform_remote_state.mp-imagebuilder.outputs.image_builder_profile
  instance_types                = local.jumpserver_pipeline.infra_config.instance_types
  name                          = local.jumpserver_pipeline.infra_config.name
  security_group_ids            = local.jumpserver_pipeline.infra_config.security_group_ids
  subnet_id                     = local.jumpserver_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.jumpserver_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = local.team_name
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "jumpserver_components" {
  //for_each = { for file in local.jumpserver_pipeline.components : file => yamldecode(file("components/jumpserver/${file}")) }
  for_each = { for comp in local.jumpserver_pipeline.components : comp.content => yamldecode(file("components/jumpserver/${comp.content}")) }

  data     = file("components/jumpserver/${each.key}")
  name     = join("_", ["nomis", trimsuffix(each.key, ".yml")])
  platform = yamldecode(file("components/jumpserver/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/jumpserver/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_distribution_configuration" "jumpserver" {
  name = local.jumpserver_pipeline.distribution.name

  distribution {
    region = local.jumpserver_pipeline.distribution.region

    ami_distribution_configuration {

      name = local.jumpserver_pipeline.distribution.ami_name

      launch_permission {
        user_ids = local.ami_share_accounts
      }

      ami_tags = {
        Name = local.jumpserver_pipeline.distribution.ami_name
      }
    }
    launch_template_configuration {
      default            = true
      account_id         = local.environment_management.account_ids["nomis-test"]
      launch_template_id = "lt-0b4eec79084daf59f"
    }
  }
}