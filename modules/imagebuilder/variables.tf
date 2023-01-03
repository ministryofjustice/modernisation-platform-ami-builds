variable "region" {
  type        = string
  description = "Infrastructure AWS region - only one region supported with current module design"
}

variable "team_name" {
  type        = string
  description = "Name of the team used to prefix resources, e.g. nomis"
}

variable "account_id" {
  type        = string
  description = "current account id"
}

variable "ami_base_name" {
  type        = string
  description = "Name of the image, e.g. rhel_7_9_baseimage"
}

variable "release_or_patch" {
  type        = string
  description = "Set to patch or release as per AMI image building strategy, e.g. patch when minor component change, release when application version change"
  default     = ""
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
  description = "A map of account names to account ids that can be used for parent_image.owner"
  default     = {}
  type        = map(string)
}

variable "components_common" {
  type = list(object({
    name    = string
    version = string
    parameters = list(object({
      name  = string
      value = string
    }))
  }))
  default     = []
  description = "The common components used to build the ami"
}

variable "components_custom" {
  type = list(object({
    path = string
    parameters = list(object({
      name  = string
      value = string
    }))
  }))
  description = "The custom components used to build the ami"
}

variable "component_template_args" {
  default     = {}
  type        = map(string)
  description = "A map of args for the custom component templates"
}

variable "components_aws" {
  type        = list(string)
  description = "The aws components used to build the ami"
}

variable "user_data" {
  type        = string
  default     = null
  description = "Ec2 user data"
}

variable "block_device_mappings_ebs" {
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
    snapshot_id = optional(string)
  }))
  description = "the block device mappings"

}

variable "parent_image" {
  type = object({
    owner              = string                      # either an ID or a name which is a key in var.account_ids_lookup
    ami_search_filters = optional(map(list(string))) # search for an ami, where the map key is the filter name and the map value is the filter values
    arn_resource_id    = optional(string)            # or specify an AMI ARN directly (the last part of ARN after arm:aws:imagebuilder:{region}:{account-id}:image/)
  })
  description = "The image this ami will be based on"
}

variable "systems_manager_agent" {
  type = object({
    uninstall_after_build = bool
  })
  description = "systems manager agent config"
}

variable "infrastructure_configuration" {
  type = object({
    instance_types = list(string)
  })
  description = "Infrastructure configuration, see aws_imagebuilder_infrastructure_configuration documentation for details on the parameters"
}

variable "account_to_distribute_ami" {
  type        = string
  description = "Account to distribute the ami"
}

variable "launch_template_exists" {
  type        = string
  description = "Whether the launch template exists, assumed to be the same as ami_base_name"
  default     = false
}

variable "image_pipeline" {
  type = object({
    schedule = object({
      schedule_expression = string
    })
  })
  description = "Pipeline configuration, see aws_imagebuilder_image_pipeline documentation for details on the parameters"
}

variable "launch_permission_account_names" {
  type        = list(string)
  description = "List of accounts that can launch the image"
}

variable "branch" {
  type        = string
  description = "Name of the branch to use for the image"
}

variable "gh_actor" {
  type        = string
  description = "Name of the GitHub actor to use for the image"
}
