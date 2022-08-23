locals {
  name             = "${var.team_name}_${var.name}"
  name_and_version = "${local.name}_${var.configuration_version}"
  default_tags = {
    pipeline-name             = local.name
    weblogic-pipeline-version = var.configuration_version
  }
  tags = merge(local.default_tags, var.tags)
}

data "aws_ami" "parent" {
  most_recent = true
  owners      = [var.image_recipe.parent_image.owner]

  filter {
    name   = "name"
    values = [var.image_recipe.parent_image.filter_name_value]
  }
}

resource "aws_imagebuilder_component" "this" {
  for_each = {
    for file in var.image_recipe.components_custom : file => yamldecode(file)
  }

  name        = each.value.name
  description = each.value.description
  platform    = each.value.parameters[1].Platform.default
  version     = each.value.parameters[0].Version.default
  data        = file(each.key)
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
    for_each = toset(var.image_recipe.components_aws)
    content {
      component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/${component.key}/x.x.x"
    }
  }

  dynamic "component" {
    for_each = toset(var.image_recipe.components_custom)
    content {
      component_arn = aws_imagebuilder_component.rhel7_9_base_components[component.key].arn
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  name                          = local.name_and_version
  instance_profile_name         = var.core_shared_services.imagebuilder_mp_tfstate.image_builder_profile
  description                   = var.description
  instance_types                = var.infrastructure_configuration.instance_types
  security_group_ids            = [var.core_shared_services.repo_tfstate.image_builder_security_group_id]
  subnet_id                     = var.core_shared_services.repo_tfstate.non_live_private_subnet_ids[0]
  terminate_instance_on_failure = true
  tags                          = local.tags
  resource_tags                 = local.tags

  logging {
    s3_logs {
      s3_bucket_name = var.core_shared_services.repo_tfstate.imagebuilder_log_bucket_id
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
      name       = local.name
      kms_key_id = var.distribution_configuration.ami_distribution_configuration.kms_key_id

      launch_permission {
        user_ids = var.distribution_configuration.ami_distribution_configuration.launch_permission_user_ids
      }

      ami_tags = local.tags
    }
  }
}

resource "aws_imagebuilder_image_pipeline" "this" {
  name                             = local.name
  description                      = var.description
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn

  schedule {
    schedule_expression = var.image_pipeline.schedule.schedule_expression
  }
}
