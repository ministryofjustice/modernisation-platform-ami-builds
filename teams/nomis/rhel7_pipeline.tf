locals {
  rhel7_user_data = <<EOF
#!/bin/bash
cd /tmp
sudo yum install -y https://s3.eu-west-2.amazonaws.com/amazon-ssm-eu-west-2/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
EOF
}

resource "aws_imagebuilder_image_pipeline" "rhel7" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.rhel7.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.rhel7.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.rhel7.arn
  name                             = local.rhel7_pipeline.pipeline.name

  #   schedule {
  #     schedule_expression                = local.rhel7_pipeline.pipeline.schedule
  #     pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  #   }

  image_tests_configuration {
    image_tests_enabled = false
  }

}

# resource "aws_imagebuilder_image" "rhel7" {
#   image_recipe_arn                 = aws_imagebuilder_image_recipe.rhel7.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.rhel7.arn
#   distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.rhel7.arn
#   image_tests_configuration {
#     image_tests_enabled = false
#   }
#   # TAGS NOT SUPPORTED FOR IMAGES
# }

data "aws_ami" "latest-rhel-79" {
  most_recent = true
  owners      = ["309956199498"] # Redhat

  filter {
    name   = "name"
    values = ["RHEL-7.9_HVM-*"]
  }
}


resource "aws_imagebuilder_image_recipe" "rhel7" {
  user_data_base64 = base64encode(local.rhel7_user_data)
  # block_device_mapping {
  #   device_name = local.rhel7_pipeline.recipe.device_name

  #   ebs {
  #     delete_on_termination = local.rhel7_pipeline.recipe.ebs.delete_on_termination
  #     volume_size           = local.rhel7_pipeline.recipe.ebs.volume_size
  #     volume_type           = local.rhel7_pipeline.recipe.ebs.volume_type
  #     encrypted             = local.rhel7_pipeline.recipe.ebs.encrypted
  #     kms_key_id            = local.rhel7_pipeline.recipe.ebs.kms_key_id
  #   }
  dynamic "block_device_mapping" {
    for_each = local.rhel7_pipeline.recipe.ebs_block_device
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
    for_each = toset(local.rhel7_pipeline.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }
  dynamic "component" {
    for_each = toset(local.rhel7_pipeline.components)
    content {
      component_arn = aws_imagebuilder_component.rhel7_components[component.key].arn
    }
  }
  lifecycle {
    create_before_destroy = true
  }

  name         = local.rhel7_pipeline.recipe.name
  parent_image = data.aws_ami.latest-rhel-79.id
  version      = local.rhel7_pipeline.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "rhel7" {
  description                   = local.rhel7_pipeline.infra_config.description
  instance_profile_name         = data.terraform_remote_state.mp-imagebuilder.outputs.image_builder_profile
  instance_types                = local.rhel7_pipeline.infra_config.instance_types
  name                          = local.rhel7_pipeline.infra_config.name
  security_group_ids            = local.rhel7_pipeline.infra_config.security_group_ids
  subnet_id                     = local.rhel7_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.rhel7_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = local.team_name
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "rhel7_components" {
  for_each = { for file in local.rhel7_pipeline.components : file => yamldecode(file("components/rhel7/${file}")) }

  data     = file("components/rhel7/${each.key}")
  name     = join("_", ["nomis", trimsuffix(each.key, ".yml")])
  platform = yamldecode(file("components/rhel7/${each.key}")).parameters[1].Platform.default
  version  = yamldecode(file("components/rhel7/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_distribution_configuration" "rhel7" {
  name = local.rhel7_pipeline.distribution.name
  kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn

  distribution {
    region = local.rhel7_pipeline.distribution.region

    ami_distribution_configuration {

      name               = local.rhel7_pipeline.distribution.ami_name
    #   target_account_ids = local.ami_share_accounts
      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }
  }
}