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

variable "parent_image" {
  type = object({
    owner             = string # either an ID or a name which is a key in var.account_ids_lookup
    filter_name_value = string
  })
}

variable "launch_template_exists" {
  type    = bool
  default = false
}

variable "configuration_version" { type = string }
variable "description" { type = string }
variable "ami_base_name" { type = string }

variable "tags" { type = map(any) }
variable "infrastructure_configuration" { type = map(any) }
variable "image_pipeline" { type = map(any) }
variable "accounts_to_distribute_ami_by_branch" { type = map(any) }

variable "block_device_mappings_ebs" {
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
}

variable "components_aws" { type = list(string) }
variable "components_custom" { type = list(string) }
