resource "aws_imagebuilder_component" "this" {
  for_each = local.components_custom_yaml

  name        = each.value.yaml.name
  description = each.value.yaml.description
  platform    = each.value.yaml.parameters[1].Platform.default
  version     = each.value.yaml.parameters[0].Version.default
  data        = each.value.raw
  kms_key_id  = local.kms_key_id
  tags        = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_image_recipe" "this" {
  name             = local.team_ami_base_name
  parent_image     = try(data.aws_ami.parent[0].id, local.ami_parent_arn)
  version          = var.configuration_version
  description      = var.description
  user_data_base64 = try(base64encode(var.user_data), null)
  tags             = local.tags

  dynamic "block_device_mapping" {
    for_each = var.block_device_mappings_ebs

    content {
      device_name = block_device_mapping.value.device_name

      ebs {
        delete_on_termination = true
        encrypted             = true
        kms_key_id            = local.kms_key_id
        volume_size           = block_device_mapping.value.volume_size
        volume_type           = block_device_mapping.value.volume_type
        snapshot_id           = block_device_mapping.value.snapshot_id # Optional ebs snapshot id
      }
    }
  }

  dynamic "component" {
    for_each = var.components_aws
    content {
      component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/${component.value}/x.x.x"
    }
  }

  dynamic "component" {
    for_each = var.components_common
    content {
      component_arn = "arn:aws:imagebuilder:${var.region}:${local.account_id}:component/${replace(component.value["name"], "_", "-")}/${component.value["version"]}"
      dynamic "parameter" {
        for_each = component.value["parameters"]
        content {
          name  = parameter.value["name"]
          value = parameter.value["value"]
        }
      }
    }
  }

  dynamic "component" {
    for_each = var.components_custom
    content {
      component_arn = aws_imagebuilder_component.this[basename(component.value["path"])].arn

      dynamic "parameter" {
        for_each = component.value["parameters"]
        content {
          name  = parameter.value["name"]
          value = parameter.value["value"]
        }
      }

    }
  }

  dynamic "systems_manager_agent" {
    for_each = var.systems_manager_agent != null ? [var.systems_manager_agent] : []
    content {
      uninstall_after_build = systems_manager_agent.value.uninstall_after_build
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  name                          = replace("${local.team_ami_base_name}_${var.configuration_version}", ".", "_")
  instance_profile_name         = local.core_shared_services.imagebuilder_mp_tfstate.image_builder_profile
  description                   = var.description
  instance_types                = var.infrastructure_configuration.instance_types
  security_group_ids            = [local.core_shared_services.repo_tfstate.image_builder_security_group_id.non_live_data]
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
  name        = local.team_ami_base_name
  description = var.description
  tags        = local.tags

  distribution {
    region = var.region

    ami_distribution_configuration {
      name        = local.ami_name
      description = var.description
      kms_key_id  = local.kms_key_id
      target_account_ids = [for account_id in local.accounts_to_distribute_ami :
        local.account_ids_lookup[account_id]
      ]
      launch_permission {
        user_ids = flatten([for name in var.launch_permission_account_names : local.account_ids_lookup[name]])
      }
      ami_tags = local.ami_tags
    }

    dynamic "launch_template_configuration" {
      for_each = var.launch_template_configurations
      content {
        account_id         = local.account_ids_lookup[launch_template_configuration.value.account_name]
        launch_template_id = launch_template_configuration.value.launch_template_id
      }
    }
  }
}

resource "aws_imagebuilder_image_pipeline" "this" {
  name                             = local.team_ami_base_name
  description                      = var.description
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn
  tags                             = local.tags
  image_tests_configuration {
    image_tests_enabled = false
  }
  schedule {
    schedule_expression                = var.image_pipeline.schedule.schedule_expression
    pipeline_execution_start_condition = var.image_pipeline.schedule.pipeline_execution_start_condition
  }
}
