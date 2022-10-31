output "parent_ami" {
  value = {
    arn = try(data.aws_ami.parent[0].arn, local.ami_parent_arn)
  }
  description = "parent AMI details, useful if looked up by a filter"
}
