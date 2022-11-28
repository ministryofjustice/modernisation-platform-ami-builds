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

variable "tags" {
  type        = map(any)
  description = "The tags for the ami"
}
