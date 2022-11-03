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
  type    = string
  default = "eu-west-2"
}
variable "user_data" {
  type    = string
  default = null
}
variable "release_or_patch" {
  type    = string
  default = ""
}

variable "parent_image" {
  type = object({
    owner              = string                      # either an ID or a name which is a key in var.account_ids_lookup
    ami_search_filters = optional(map(list(string))) # search for an ami, where the map key is the filter name and the map value is the filter values
    arn_resource_id    = optional(string)
  })
}

variable "launch_template_exists" {
  type    = bool
  default = false
}

variable "configuration_version" { type = string }
variable "description" { type = string }
variable "ami_base_name" { type = string }
variable "team_name" { type = string }
variable "account_to_distribute_ami" { type = string }

variable "tags" { type = map(any) }
variable "infrastructure_configuration" { type = map(any) }
variable "image_pipeline" { type = map(any) }


variable "block_device_mappings_ebs" {
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
}

variable "components_aws" { type = list(string) }
variable "components_custom" { type = list(string) }
variable "launch_permission_account_names" { type = list(string) }