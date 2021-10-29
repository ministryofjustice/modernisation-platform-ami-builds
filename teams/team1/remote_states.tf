data "terraform_remote_state" "modernisation-platform-repo" {
  backend = "s3"
  config = {
    bucket = "modernisation-platform-terraform-state"
    key = "environments/accounts/core-shared-services/core-shared-services-production/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "mp-imagebuilder" {
  backend = "s3"
  config = {
    bucket = "modernisation-platform-terraform-state"
    key = "environments/accounts/core-shared-services/core-shared-services-production/imagebuilder-mp.tfstate"
    region = "eu-west-2"
  }
}
