resource "aws_imagebuilder_component" "this" {
  for_each = local.components_custom_yaml

  name        = each.value.name
  description = each.value.description
  platform    = each.value.parameters[1].Platform.default
  version     = each.value.parameters[0].Version.default
  data        = file(each.key)
  kms_key_id  = var.kms_key_id
  tags        = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_image_recipe" "this" {
  name             = local.name
  parent_image     = data.aws_ami.parent.id
  version          = var.configuration_version
  description      = var.description
  user_data_base64 = try(base64encode(var.image_recipe.user_data), null)
  tags             = local.tags

  dynamic "block_device_mapping" {
    for_each = var.image_recipe.block_device_mappings_ebs

    content {
      device_name = block_device_mapping.value.device_name

      ebs {
        delete_on_termination = true
        encrypted             = true
        kms_key_id            = var.kms_key_id
        volume_size           = block_device_mapping.value.volume_size
        volume_type           = block_device_mapping.value.volume_type
      }
    }
  }

  dynamic "component" {
    for_each = toset(var.image_recipe.components_aws)
    content {
      component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/${component.key}/x.x.x"
    }
  }

  dynamic "component" {
    for_each = toset(var.image_recipe.components_custom)
    content {
      component_arn = aws_imagebuilder_component.this[component.key].arn
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  systems_manager_agent {
    uninstall_after_build = false
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  name                          = local.name_and_version
  instance_profile_name         = local.core_shared_services.imagebuilder_mp_tfstate.image_builder_profile
  description                   = var.description
  instance_types                = var.infrastructure_configuration.instance_types
  security_group_ids            = [local.core_shared_services.repo_tfstate.image_builder_security_group_id]
  subnet_id                     = local.core_shared_services.repo_tfstate.non_live_private_subnet_ids[0]
  terminate_instance_on_failure = true
  tags                          = local.tags
  resource_tags                 = local.tags

  logging {
    s3_logs {
      s3_bucket_name = local.core_shared_services.repo_tfstate.imagebuilder_log_bucket_id
      s3_key_prefix  = var.team_name
    }
  }
}

resource "aws_imagebuilder_distribution_configuration" "this" {
  name        = local.name
  description = var.description
  tags        = local.tags

  distribution {
    region = var.region

    ami_distribution_configuration {
      name               = local.ami_name
      description        = var.description
      kms_key_id         = lookup(var.distribution_configuration.ami_distribution_configuration, "kms_key_id", var.kms_key_id)
      target_account_ids = lookup(var.distribution_configuration.ami_distribution_configuration, "target_account_ids", null)
      ami_tags           = local.ami_tags
    }
  }
}

resource "aws_imagebuilder_image_pipeline" "this" {
  name                             = local.name
  description                      = var.description
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn
  tags                             = local.tags
  image_tests_configuration {
    image_tests_enabled = false
  }
  schedule {
    schedule_expression = var.image_pipeline.schedule.schedule_expression
  }
}
