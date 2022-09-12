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

variable "account_ids_lookup" {
  description = "A map of account names to account ids that can be used for image_recipe.parent_image.owner"
  default     = {}
}

variable "image_recipe" {
  type = object({
    parent_image = object({
      owner             = string # either an ID or a name which is a key in var.account_ids_lookup
      filter_name_value = string
    })
    user_data = optional(string)
    block_device_mappings_ebs = list(object({
      device_name = string
      volume_size = number
      volume_type = string
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

variable "branch" {
  type        = string
  description = "Name of the branch to use for the image"
}

variable "gh_actor" {
  type        = string
  description = "Name of the GitHub actor to use for the image"
}
