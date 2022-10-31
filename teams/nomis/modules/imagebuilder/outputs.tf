output "parent_ami_arn" {
  value       = try(data.aws_ami.parent[0].arn, local.ami_parent_arn)
  description = "Map of common firewall policy rules"
}
