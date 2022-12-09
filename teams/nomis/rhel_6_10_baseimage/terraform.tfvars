# following are passed in via pipeline
# BRANCH_NAME =
# GH_ACTOR_NAME =

imagebuilders = {
}

distribution_configuration_by_branch = {
  default = {
    ami_distribution_configuration = {
      target_account_names = [
        "core-shared-services-production"
      ]
      launch_permission_account_names = [
        "core-shared-services-production",
        "nomis-development",
        "nomis-test",
        "oasys-development",
        "oasys-test"
      ]
    }

    launch_template_configuration = {
      account_name       = "nomis-development"
      launch_template_id = "lt-04af9b9914ae9a578"
    }
  }
}
