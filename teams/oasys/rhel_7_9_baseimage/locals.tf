locals {

  distribution_configuration_by_branch = {
    # push to main branch
    main = {
      ami_distribution_configuration = { # which accounts to distibute the ami
        target_account_ids_or_names = [
          #"core-shared-services-production",
          "oasys-test"
        ]
      }

      # launch_template_configuration = { # this block creates a launch template
      #   account_id_or_name = "oasys-test"
      #   launch_template_id = data.aws_launch_template.rhel_7_9_baseimage.id
      # }
    }

    # push to any other branch / local run
    default = {
      ami_distribution_configuration = { # which accounts to distibute the ami
        target_account_ids_or_names = [
          #"core-shared-services-production",
          "oasys-test"
        ]
      }

      # launch_template_configuration = { # this block creates a launch template
      #   account_id_or_name = "oasys-test"
      #   launch_template_id = data.aws_launch_template.rhel_7_9_baseimage.id
      # }
    }
  }
}

