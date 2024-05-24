# Backend
terraform {
  # `backend` blocks do not support variables, so the following are hard-coded here:
  # - S3 bucket name, which is created in modernisation-platform-account/s3.tf
  backend "s3" {
    acl                  = "bucket-owner-full-control"
    bucket               = "modernisation-platform-terraform-state"
    encrypt              = true
    key                  = "terraform.tfstate" # replace team1 with your team name when copying this file
    region               = "eu-west-2"
    workspace_key_prefix = "environments/members/testing/testing-test" # This will store the object as environments/core-shared-services/${workspace}/imagebuilder-[team name].tfstate
  }
}
