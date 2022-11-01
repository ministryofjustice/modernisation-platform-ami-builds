locals {
  # some of the outputs contain sensitive ids, so just output interesting stuff
  parent_ami_output_keys = [
    "creation_date",
    "deprecation_time",
    "description",
    "ena_support",
    "id",
    "name",
    "state",
    "usage_operation",
    "virtualization_type"
  ]
}

output "parent_ami" {
  value = try(
    {
      for key, value in data.aws_ami.parent[0] : key => value if contains(local.parent_ami_output_keys, key)
    },
    {
      descripion = "data.aws_ami output not provided when ARN used to specify parent"
    }
  )
  description = "parent AMI details from aws_ami name filter lookup"
}
