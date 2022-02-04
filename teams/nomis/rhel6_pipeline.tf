resource "aws_imagebuilder_image_pipeline" "rhel6" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.rhel6.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.rhel6.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.rhel6.arn
  name                             = local.rhel6_pipeline.pipeline.name

  schedule {
    schedule_expression                = local.rhel6_pipeline.pipeline.schedule
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

}

data "aws_ami" "latest-rhel-610" {
most_recent = true
owners = ["309956199498"] # Redhat

  filter {
      name   = "name"
      values = ["RHEL-6.10_HVM-*"]
  }
}


resource "aws_imagebuilder_image_recipe" "rhel6" {
  block_device_mapping {
    device_name = local.rhel6_pipeline.recipe.device_name

    ebs {
      delete_on_termination = local.rhel6_pipeline.recipe.ebs.delete_on_termination
      volume_size           = local.rhel6_pipeline.recipe.ebs.volume_size
      volume_type           = local.rhel6_pipeline.recipe.ebs.volume_type
      encrypted             = local.rhel6_pipeline.recipe.ebs.encrypted
      //kms_key_id            = data.aws_kms_key.sprinkler_ebs_encryption_key.arn
    #TODO: Turn on encryption with nomis cmk
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
