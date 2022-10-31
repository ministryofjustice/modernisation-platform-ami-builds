output "parent_ami" {
  value = try(data.aws_ami.parent[0], {
    descripion = "data.aws_ami output not provided when ARN used to specify parent"
  })
  description = "parent AMI details from aws_ami name filter lookup"
}
