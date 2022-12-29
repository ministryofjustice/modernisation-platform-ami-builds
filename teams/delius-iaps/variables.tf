variable "BRANCH_NAME" {
  type        = string
  default     = "main"
  description = "Github actions running branch"
}
variable "GH_ACTOR_NAME" {
  type        = string
  default     = ""
  description = "GH username triggering Github action"
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "Infrastructure AWS region - only one region supported with current module design"
}
variable "user_data" {
  type        = string
  default     = null
  description = "Ec2 user data"
}
variable "release_or_patch" {
  type        = string
  default     = ""
  description = "Set to patch or release as per AMI image building strategy, e.g. patch when minor component change, release when application version change"
}

variable "parent_image" {
  type = object({
    owner              = string                      # either an ID or a name which is a key in var.account_ids_lookup
    ami_search_filters = optional(map(list(string))) # search for an ami, where the map key is the filter name and the map value is the filter values
    arn_resource_id    = optional(string)
  })
  description = "The image this ami will be based on"
}

variable "launch_template_exists" {
  type        = bool
  default     = false
  description = "Whether the launch template exists or not"
}

variable "configuration_version" {
  type        = string
  description = "Version number of this configuration, increment on changes, e.g. 1.0.1"
}
variable "description" {
  type        = string
  description = "Description of the image"
}
variable "ami_base_name" {
  type        = string
  description = "e.g. rhel_7_9"
}
variable "ami_name_prefix" {
  type        = string
  description = "the prefix to the ami name"
  default     = "baseimage"
}
variable "account_to_distribute_ami" {
  type        = string
  description = "Account that you will distribute the ami to"
}

variable "tags" {
  type        = map(any)
  description = "The tags for the ami"
}
variable "infrastructure_configuration" {
  type        = map(any)
  description = "Infrastructure configuration, see aws_imagebuilder_infrastructure_configuration documentation for details on the parameters"
}
variable "image_pipeline" {
  type        = map(any)
  description = "Pipeline configuration, see aws_imagebuilder_image_pipeline documentation for details on the parameters"
}


variable "block_device_mappings_ebs" {
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
    snapshot_id = string
  }))
  description = "the block device mappings"
}

variable "systems_manager_agent" {
  type = object({
    uninstall_after_build = bool
  })
  description = "systems manager agent config"
  default     = null
}

variable "components_aws" {
  type        = list(string)
  description = "The aws components used to build the ami"
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
variable "launch_permission_accounts_by_branch" {
  type        = map(any)
  description = "The list of accounts to give launch permissions to by branch"
}