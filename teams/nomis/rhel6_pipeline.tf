locals {
  user_data = <<EOF
#!/bin/bash
cd /tmp
curl -v https://s3.eu-west-2.amazonaws.com/amazon-ssm-eu-west-2/3.0.1390.0/linux_amd64/
sudo yum install -y https://s3.eu-west-2.amazonaws.com/amazon-ssm-eu-west-2/3.0.1390.0/linux_amd64/amazon-ssm-agent.rpm
sudo yum install -y https://amazon-ssm-eu-west-2.vpce-07d0af580b95a4c4d-cf3bt1wh.s3.eu-west-2.vpce.amazonaws.com/3.0.1390.0/linux_amd64/amazon-ssm-agent.rpm
sudo start amazon-ssm-agent
EOF
}

# resource "aws_imagebuilder_image_pipeline" "rhel6" {
#   image_recipe_arn                 = aws_imagebuilder_image_recipe.rhel6.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.rhel6.arn
#   distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.rhel6.arn
#   name                             = local.rhel6_pipeline.pipeline.name

# #   schedule {
# #     schedule_expression                = local.rhel6_pipeline.pipeline.schedule
# #     pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
# #   }

# }

resource "aws_imagebuilder_image" "rhel6" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.rhel6.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.rhel6.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.rhel6.arn
  image_tests_configuration {
    image_tests_enabled = false
  }
  # TAGS NOT SUPPORTED FOR IMAGES
}

data "aws_ami" "latest-rhel-610" {
  most_recent = true
  owners      = ["309956199498"] # Redhat

  filter {
    name   = "name"
    values = ["RHEL-6.10_HVM-*"]
  }
}

# changing ebs mapping
resource "aws_imagebuilder_image_recipe" "rhel6" {
  user_data_base64 = base64encode(local.user_data)
  dynamic "block_device_mapping" {
    for_each = local.rhel6_pipeline.recipe.ebs_block_device
    content {
      device_name = block_device_mapping.value.device_name
      ebs {
        delete_on_termination = lookup(block_device_mapping.value, "delete_on_termination", null)
        encrypted             = lookup(block_device_mapping.value, "encrypted", null)
        kms_key_id            = lookup(block_device_mapping.value, "kms_key_id", null)
        volume_size           = lookup(block_device_mapping.value, "volume_size", null)
        volume_type           = lookup(block_device_mapping.value, "volume_type", null)
      }
    }
  }

  dynamic "component" {
    for_each = toset(local.rhel6_pipeline.components)
    content {
      component_arn = aws_imagebuilder_component.rhel6_components[component.key].arn
    }
  }

  dynamic "component" {
    for_each = toset(local.rhel6_pipeline.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  name         = local.rhel6_pipeline.recipe.name
  parent_image = data.aws_ami.latest-rhel-610.id
  version      = local.rhel6_pipeline.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "rhel6" {
  description                   = local.rhel6_pipeline.infra_config.description
  instance_profile_name         = data.terraform_remote_state.mp-imagebuilder.outputs.image_builder_profile
  instance_types                = local.rhel6_pipeline.infra_config.instance_types
  name                          = local.rhel6_pipeline.infra_config.name
  security_group_ids            = local.rhel6_pipeline.infra_config.security_group_ids
  subnet_id                     = local.rhel6_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.rhel6_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = local.team_name
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "rhel6_components" {
  for_each = { for file in local.rhel6_pipeline.components : file => yamldecode(file("components/rhel6/${file}")) }

  data     = file("components/rhel6/${each.key}")
  name     = join("_", ["nomis", trimsuffix(each.key, ".yml")])
  platform = yamldecode(file("components/rhel6/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/rhel6/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_distribution_configuration" "rhel6" {
  name = local.rhel6_pipeline.distribution.name

  distribution {
    region = local.rhel6_pipeline.distribution.region

    ami_distribution_configuration {

      name = local.rhel6_pipeline.distribution.ami_name

      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }
  }
}
