resource "aws_imagebuilder_image_pipeline" "TestPipeline" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.TestRecipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.TestInfraConfig.arn
  name                             = local.pipeline.name

  schedule {
    schedule_expression = local.pipeline.schedule
  }
}

/* This is being commented for reference, it is not necessary to deploy this and it takes a long time to apply.
resource "aws_imagebuilder_image" "TestImage" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.TestDistributionConfig.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.TestRecipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.TestInfraConfig.arn
}
*/


resource "aws_imagebuilder_image_recipe" "TestRecipe" {
  block_device_mapping {
    device_name = local.recipe.device_name

    ebs {
      delete_on_termination = local.recipe.ebs.delete_on_termination
      volume_size           = local.recipe.ebs.volume_size
      volume_type           = local.recipe.ebs.volume_type
    }
  }

  component {
    component_arn = aws_imagebuilder_component.TestComponent.arn
  }

  name         = local.recipe.name
  parent_image = local.recipe.parent_image
  version      = local.recipe.version
}



resource "aws_imagebuilder_infrastructure_configuration" "TestInfraConfig" {
  description                   = local.infra_config.description
  instance_profile_name         = aws_iam_instance_profile.image_builder_profile.name
  instance_types                = local.infra_config.instance_types
  name                          = local.infra_config.name
  security_group_ids            = local.infra_config.security_group_ids
  subnet_id                     = local.infra_config.subnet_id
  terminate_instance_on_failure = local.infra_config.terminate_on_fail

}

resource "aws_imagebuilder_component" "TestComponent" {
  data = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        action = "ExecuteBash"
        inputs = {
          commands = ["echo 'hello world'"]
        }
        name      = "example"
        onFailure = "Continue"
      }]
    }]
    schemaVersion = 1.0
  })
  name     = "example"
  platform = "Linux"
  version  = "1.0.1"
}


resource "aws_imagebuilder_distribution_configuration" "TestDistributionConfig" {
  name = local.distribution.name

  distribution {
    region = local.distribution.region

    ami_distribution_configuration {
        name = local.distribution.ami_name
    }
  }
}
