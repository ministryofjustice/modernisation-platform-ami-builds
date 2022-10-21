locals {

  distribution_configuration_by_branch = {
    # push to main branch
    main = {
      ami_distribution_configuration = {
        target_account_ids_or_names = [
          "core-shared-services-production",
          "oasys-development"
        ]
      }

      launch_template_configuration = {
        account_id_or_name = "oasys-development"
        launch_template_id = data.aws_launch_template.base_rhel_7_9.id
      }
    }

    # push to any other branch / local run
    default = {
      ami_distribution_configuration = {
        target_account_ids_or_names = [
          "core-shared-services-production",
          "oasys-development"
        ]
      }

      launch_template_configuration = {
        account_id_or_name = "oasys-development"
        launch_template_id = data.aws_launch_template.base_rhel_7_9.id
      }
    }
  }
}

