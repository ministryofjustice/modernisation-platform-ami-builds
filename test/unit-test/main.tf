module "imagebuilder" {
  source = "./../../modules//imagebuilder"

  region                          = "eu-west-2"
  team_name                       = "testing"
  ami_base_name                   = "windows_server_2022"
  configuration_version           = "0.2.1"
  description                     = "windows server 2022 Test"
  release_or_patch                = "release"
  tags                            = merge(local.shared_tags)
  parent_image = {
    owner           = "core-shared-services-production"
    arn_resource_id = "mp-windowsserver2022/x.x.x"
  }
  block_device_mappings_ebs = [
  {
    device_name = "/dev/sda1" # root volume
    volume_size = 30
    volume_type = "gp3"
  }
  ] 
  components_aws = [
    "amazon-cloudwatch-agent-windows",
    "ec2launch-v2-windows"
  ]
  components_common               = []
  components_custom               = []
  component_template_args         = {}
  user_data                       = var.user_data
  infrastructure_configuration = {
    instance_types = ["t2.nano"]
  }

  accounts_to_distribute_ami      = ["testing-test"]
  launch_permission_account_names = ["testing-test"]
  launch_template_exists          = false
  image_pipeline = {
    schedule = {
      schedule_expression                = "cron(0 0 2 * ? *)"
      pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
    }
  }
  systems_manager_agent = {
    uninstall_after_build = false
  }
  branch                          = var.BRANCH_NAME
  gh_actor                        = var.GH_ACTOR_NAME
}
