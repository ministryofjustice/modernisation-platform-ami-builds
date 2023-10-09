output "image_builder_security_group" {
  value = local.core_shared_services.repo_tfstate.image_builder_security_group_id
  description = "Output the entire object to inspect its attributes"
}