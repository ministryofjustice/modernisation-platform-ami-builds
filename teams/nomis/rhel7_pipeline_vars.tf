locals {
  rhel7_version = "1.0.3"

  rhel7_pipeline = {

    pipeline = {
      name     = join("", [local.team_name, "_RHEL7_9", replace(local.rhel7_version, ".", "_")])
      schedule = "rate(1 hour)"
    }

    recipe = {
      name           = join("", [local.team_name, "_RHEL7_9", replace(local.rhel7_version, ".", "_")])
      parent_account = "309956199498" #RedHat
      version        = local.rhel7_version
      # device_name = "/dev/sda1"

      # ebs = {
      #   delete_on_termination = true
      #   volume_size           = 30
      #   volume_type           = "gp2"
      #   encrypted             = true
      #   kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
      # }
      ebs_block_device = [
        {
          device_name           = "/dev/sda1"
          volume_type           = "gp3"
          volume_size           = 30
          encrypted             = true
          kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
          delete_on_termination = true
        },
        {
          device_name           = "/dev/sdb"
          volume_type           = "gp3"
          volume_size           = 100
          encrypted             = true
          kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
          delete_on_termination = true
        },
        {
          device_name           = "/dev/sdc"
          volume_type           = "gp3"
          volume_size           = 100
          encrypted             = true
          kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
          delete_on_termination = true
        },
        {
          device_name           = "/dev/sde"
          volume_type           = "gp3"
          volume_size           = 1
          encrypted             = true
          kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
          delete_on_termination = true
        },
        {
          device_name           = "/dev/sdf"
          volume_type           = "gp3"
          volume_size           = 1
          encrypted             = true
          kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
          delete_on_termination = true
        },
        {
          device_name           = "/dev/sds"
          volume_type           = "gp3"
          volume_size           = 16
          encrypted             = true
          kms_key_id            = data.aws_kms_key.ebs_encryption_cmk.arn
          delete_on_termination = true
        }


      ]
    }

    infra_config = {
      description        = "RHEL 7_9 Base Image for Oracle"
      instance_types     = ["t3.large"]
      name               = join("", [local.team_name, "_RHEL7_9", replace(local.rhel7_version, ".", "_")])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = "${data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]}"
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_RHEL7_9", replace(local.rhel7_version, ".", "_")])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_RHEL7_9_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "database.yml"
    ]

    aws_components = [
      "stig-build-linux-medium", "scap-compliance-checker-linux", "aws-cli-version-2-linux", "amazon-cloudwatch-agent-linux"
    ]

  }

}