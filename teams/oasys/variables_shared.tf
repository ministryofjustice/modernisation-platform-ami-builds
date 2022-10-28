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

variable "ami_base_name"         { 
  type        = string
  description = "Main part of the ami name, before pre/suffixes.
                 Should be the same as this dir name
                 Needs a launch template created in https://github.com/ministryofjustice/modernisation-platform-environments with the same name."
}
variable "configuration_version" { type = string }
variable "description"           { type = string }

variable "tags"                         { type = map(any) }
variable "image_recipe"                 { type = map(any) }
variable "infrastructure_configuration" { type = map(any) }
variable "image_pipeline"               { type = map(any) }

variable "launch_template_exists" { type = bool }
