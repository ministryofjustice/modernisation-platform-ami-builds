locals {
  user_data = <<EOF
#!/bin/bash
cd /tmp
sudo yum install -y https://s3.eu-west-2.amazonaws.com/amazon-ssm-eu-west-2/3.0.1390.0/linux_amd64/amazon-ssm-agent.rpm
sudo start amazon-ssm-agent
wget https://s3.eu-west-2.amazonaws.com/amazoncloudwatch-agent-eu-west-2/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
EOF
}

resource "aws_imagebuilder_image_pipeline" "weblogic" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.weblogic.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.weblogic.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.weblogic.arn
  name                             = local.weblogic_pipeline.pipeline.name
  image_tests_configuration {
    image_tests_enabled = false
  }

}

# resource "aws_imagebuilder_image" "weblogic" {
#   image_recipe_arn                 = aws_imagebuilder_image_recipe.weblogic.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.weblogic.arn
#   distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.weblogic.arn
#   image_tests_configuration {
#     image_tests_enabled = false
#   }
#   # TAGS NOT SUPPORTED FOR IMAGES
# }

data "aws_ami" "latest-rhel-610" {
  most_recent = true
  owners      = ["309956199498"] # Redhat

  filter {
    name   = "name"
    values = ["RHEL-6.10_HVM-*"]
  }
}

# changing ebs mapping
resource "aws_imagebuilder_image_recipe" "weblogic" {
  user_data_base64 = base64encode(local.user_data)
  dynamic "block_device_mapping" {
    for_each = local.weblogic_pipeline.recipe.ebs_block_device
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
    for_each = toset(local.weblogic_pipeline.aws_components)
    content {
      component_arn = "arn:aws:imagebuilder:eu-west-2:aws:component/${component.key}/x.x.x"
    }
  }
  dynamic "component" {
    for_each = toset(local.weblogic_pipeline.components)
    content {
      component_arn = aws_imagebuilder_component.weblogic_components[component.key].arn
    }
  }


  lifecycle {
    create_before_destroy = true
  }

  name         = local.weblogic_pipeline.recipe.name
  parent_image = data.aws_ami.latest-rhel-610.id
  version      = local.weblogic_pipeline.recipe.version
}


resource "aws_imagebuilder_infrastructure_configuration" "weblogic" {
  description                   = local.weblogic_pipeline.infra_config.description
  instance_profile_name         = data.terraform_remote_state.mp-imagebuilder.outputs.image_builder_profile
  instance_types                = local.weblogic_pipeline.infra_config.instance_types
  name                          = local.weblogic_pipeline.infra_config.name
  security_group_ids            = local.weblogic_pipeline.infra_config.security_group_ids
  subnet_id                     = local.weblogic_pipeline.infra_config.subnet_id
  terminate_instance_on_failure = local.weblogic_pipeline.infra_config.terminate_on_fail

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.modernisation-platform-repo.outputs.imagebuilder_log_bucket_id
      s3_key_prefix  = local.team_name
    }
  }
}

// create each component in team directory
resource "aws_imagebuilder_component" "weblogic_components" {
  for_each = { for file in local.weblogic_pipeline.components : file => yamldecode(file("components/weblogic/${file}")) }

  data       = file("components/weblogic/${each.key}")
  name       = join("_", ["nomis", trimsuffix(each.key, ".yml")])
  kms_key_id = data.aws_kms_key.ebs_encryption_cmk.arn
  platform   = yamldecode(file("components/weblogic/${each.key}")).parameters[1].Platform.default
  version    = yamldecode(file("components/weblogic/${each.key}")).parameters[0].Version.default

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_distribution_configuration" "weblogic" {
  name = local.weblogic_pipeline.distribution.name

  distribution {
    region = local.weblogic_pipeline.distribution.region

    ami_distribution_configuration {

      name       = local.weblogic_pipeline.distribution.ami_name
      kms_key_id = data.aws_kms_key.ebs_encryption_cmk.arn

      launch_permission {
        user_ids = local.ami_share_accounts
      }
    }

    launch_template_configuration {
      default            = true
      account_id         = local.environment_management.account_ids["nomis-test"]
      launch_template_id = data.aws_launch_template.weblogic-launch-templates.id
    }
  }
}