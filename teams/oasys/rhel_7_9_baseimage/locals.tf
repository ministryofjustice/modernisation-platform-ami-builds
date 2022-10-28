locals {

  accounts_to_distribute_ami_by_branch = {
    main = [
      #"core-shared-services-production",
      "oasys-development"
    ]
    default = [
      #"core-shared-services-production",
      "oasys-development"
    ]
  }
}

