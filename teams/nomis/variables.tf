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

variable "run_ansible_from_branch" {
  type        = bool
  default     = false
  description = "Run Ansible components from working branch"
}
