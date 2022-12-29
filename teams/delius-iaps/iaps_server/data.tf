# data "aws_ebs_snapshot" "windows_server_2022_installation_media" {
#   most_recent = true
#   filter {
#     name   = "owner-alias"
#     values = ["amazon"]
#   }
#   filter {
#     name   = "description"
#     values = ["Windows 2022 English Installation Media"]
#   }
# }
