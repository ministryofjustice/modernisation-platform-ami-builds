locals {
  user_data = <<EOF
#!/bin/bash
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
EOF
}

resource "aws_imagebuilder_image_pipeline" "database" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.database.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.database.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.database.arn
  name                             = local.database_pipeline.pipeline.name

  # schedule {
  #   schedule_expression                = local.database_pipeline.pipeline.schedule
  #   pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  # }

}

data "aws_ami" "database" {
  most_recent = true
  owners      = [local.database_pipeline.recipe.parent_account]

  filter {
    name   = "name"
    values = [local.database_pipeline.recipe.parent_image]
  }
}

resource "aws_imagebuilder_image_recipe" "database" {
  user_data_base64 = base64encode(local.user_data)
  dynamic "block_device_mapping" {
    for_each = local.database_pipeline.recipe.ebs_block_device
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
    for_each = toset(local.database_pipeline.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }
  dynamic "component" {
    for_each = toset(local.database_pipeline.components)
    content {
      component_arn = aws_imagebuilder_component.database_components[component.key].arn
    }
  }


  lifecycle {
    create_before_destroy = true
  }

  name              = local.database_pipeline.recipe.name
  parent_image      = data.aws_ami.database.id
  version           = local.database_pipeline.recipe.version
  working_directory = local.database_pipeline.recipe.working_directory

  systems_manager_agent {
    uninstall_after_build = false
  }
}


resource "aws_imagebuilder_infrastructure_configuration" "database" {
  description                   = local.database_pipeline.infra_config.description
  instance_profile_name         = data.terraform_remote_state.mp-imagebuilder.outputs.image_builder_profile
  instance_types                = local.database_pipeline.infra_config.instance_types
  name                          = local.database_pipeline.infra_config.name
  security_group_ids            = local.database_pipeline.infra_config.security_group_ids
  subnet_id                     = local.database_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.database_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = local.team_name
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "database_components" {
  for_each = { for file in local.database_pipeline.components : file => yamldecode(file("components/database/${file}")) }

  data     = file("components/database/${each.key}")
  name     = join("_", ["nomis", trimsuffix(each.key, ".yml")])
  platform = yamldecode(file("components/database/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/database/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_distribution_configuration" "database" {
  name = local.database_pipeline.distribution.name

  distribution {
    region = local.database_pipeline.distribution.region

    ami_distribution_configuration {

      name               = local.database_pipeline.distribution.ami_name
      target_account_ids = local.ami_share_accounts
      # launch_permission {
      #   user_ids = local.ami_share_accounts
      # }

      ami_tags = {
        Name = local.database_pipeline.distribution.ami_name
      }
    }
  }
}