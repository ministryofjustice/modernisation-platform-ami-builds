include {
  path = find_in_parent_folders()
}
terraform {
  source = "../..//baseimages" # path_relative_from_include()
}
