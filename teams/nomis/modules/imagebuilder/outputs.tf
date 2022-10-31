output "parent_ami" {
  value       = try(data.aws_ami.parent[0], {})
  description = "parent AMI details, useful if looked up by a filter"
}
