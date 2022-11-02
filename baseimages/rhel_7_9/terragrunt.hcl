include {
  path = find_in_parent_folders()
}
terraform {
  source = path_relative_from_include()
}

inputs = {
  ami_base_name = path_relative_to_include()
}