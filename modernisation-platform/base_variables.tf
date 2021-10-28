variable "networking" {

  type = list(any)

}

resource "random_shuffle" "image_builder_subnet_ids" {
  input        = data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_subnet_ids
  result_count = 1

}
