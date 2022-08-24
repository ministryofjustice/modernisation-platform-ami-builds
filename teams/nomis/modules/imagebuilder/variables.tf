variable "region" {
  type        = string
  description = "Infrastructure AWS region - only one region supported with current module design"
}

variable "team_name" {
  type        = string
  description = "Name of the team used to prefix resources, e.g. nomis"
}

variable "name" {
  type        = string
  description = "Name of the image, e.g. rhel79_base"
}

variable "configuration_version" {
  type        = string
  description = "Version number of this configuration, increment on changes, e.g. 1.0.1"
}

variable "description" {
  type        = string
  description = "Description of the image"
}

variable "tags" {
  type        = map(string)
  description = "Set of tags to apply to resources"
}

variable "kms_key_id" {
  type        = string
  description = "Encryption key to apply to image and components"
  default     = null
}

variable "image_recipe" {
  type = object({
    parent_image = object({
      owner             = string
      filter_name_value = string
    })
    # user_data = string 
    block_device_mappings_ebs = list(object({
      device_name = string
    }))
    components_aws    = list(string)
    components_custom = list(string)
  })
  description = "Details of image builder recipe, see aws_imagebuilder_image_recipe documentation for details on the parameters"
}

variable "infrastructure_configuration" {
  type = object({
    instance_types = list(string)
  })
  description = "Infrastructure configuration, see aws_imagebuilder_infrastructure_configuration documentation for details on the parameters"
}

variable "distribution_configuration" {
  type = object({
    ami_distribution_configuration = object({
      target_account_ids = list(string)
    })
  })
  description = "Distribution configuration, see aws_imagebuilder_distribution_configuration documentation for details on the parameters"
}

variable "image_pipeline" {
  type = object({
    schedule = object({
      schedule_expression = string
    })
  })
  description = "Pipeline configuration, see aws_imagebuilder_image_pipeline documentation for details on the parameters"
}

variable "core_shared_services" {
  # Set the tfstate variables to the corresponding data.terraform_remote_state output
  # type = object({
  #   repo_tfstate
  #   imagebuilder_mp_tfstate
  # })
  description = "core-shared-services terraform state outputs"
}
