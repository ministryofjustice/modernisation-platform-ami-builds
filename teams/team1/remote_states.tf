data "terraform_remote_state" "modernisation-platform-repo" {
  backend = "s3"
  config  = {
    bucket = "modernisation-platform-terraform-state"
    key = "environments/accounts/core-sandbox/core-sandbox-dev/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "mp-imagebuilder" {
  backend = "s3"
  config  = {
    bucket = "modernisation-platform-terraform-state"
    key = "environments/accounts/core-sandbox/core-sandbox-dev/imagebuilder.tfstate"
    region = "eu-west-2"
  }
}
