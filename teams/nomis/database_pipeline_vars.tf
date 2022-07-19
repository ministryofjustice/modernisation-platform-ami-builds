locals {
  database_pipeline = {
    pipeline = {
      name     = join("", [local.team_name, "_database"])
      schedule = "cron(0 0 1 * ? *)"
    }

    recipe = {
      name              = join("", [local.team_name, "_database"])
      parent_account    = "309956199498" #RedHat
      parent_image      = "RHEL-7.9_HVM-*"
      version           = "1.0.1"
      working_directory = "/tmp"

      ebs_block_device = [
        {
          device_name           = "/dev/sda1" # root volume
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 30
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sdb" # /u01 oracle app disk
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 100
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sdc" # /u02 oracle app disk
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 100
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sds" # swap disk
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 4
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sde" # oracle asm disk DATA01
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 1
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sdf" # oracle asm disk DATA02
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 1
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sdg" # oracle asm disk DATA03
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 1
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sdh" # oracle asm disk DATA04
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 1
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sdi" # oracle asm disk DATA05
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 1
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sdj" # oracle asm disk FLASH01
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 1
          volume_type           = "gp3"
        },
        {
          device_name           = "/dev/sdk" # oracle asm disk FLASH02
          encrypted             = true
          kms_key_id            = data.aws_kms_key.hmpps_ebs_encryption_cmk.arn
          delete_on_termination = true
          volume_size           = 1
          volume_type           = "gp3"
        }
      ]
    }

    infra_config = {
      description        = "RHEL 7_9 Image for database"
      instance_types     = ["t3.medium"]
      name               = join("", [local.team_name, "_database"])
      security_group_ids = [data.terraform_remote_state.modernisation-platform-repo.outputs.image_builder_security_group_id]
      subnet_id          = "${data.terraform_remote_state.modernisation-platform-repo.outputs.non_live_private_subnet_ids[0]}"
      terminate_on_fail  = true
    }

    distribution = {
      name     = join("", [local.team_name, "_database_"])
      region   = "eu-west-2"
      ami_name = join("", [local.team_name, "_database_{{ imagebuilder:buildDate }}"])
    }

    components = [
      "database.yml"
    ]

    aws_components = [
      "update-linux",
      "stig-build-linux-medium",
      "aws-cli-version-2-linux",
      "amazon-cloudwatch-agent-linux"
    ]

  }

}