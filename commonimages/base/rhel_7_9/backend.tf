
terraform {
  backend "s3" {
    bucket               = "modernisation-platform-terraform-state"
    key                  = "ami-commonimages/rhel_7_9.tfstate"
    region               = "eu-west-2"
    encrypt              = true
    acl                  = "bucket-owner-full-control"
    workspace_key_prefix = "environments/accounts/core-shared-services" # This will store the object as environments/core-shared-services/${workspace}/imagebuilder-[team name].tfstate
  }
}
