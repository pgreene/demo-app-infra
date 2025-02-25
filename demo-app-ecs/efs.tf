module "kms" {
  source = "app.terraform.io/pgconsulting/kms/aws"
  version = "1.0.1"
  description = "used for demo-app efs"
  kms_is_enabled = true
  enable_key_rotation = true
  deletion_window_in_days = 7
  tags = local.tags
}

module "efs_file_system" {
  source = "app.terraform.io/pgconsulting/efs-file-system/aws"
  version = "1.0.0"
  creation_token = local.name
  kms_key_id = module.kms.arn
  encrypted = true
  #encrypted = false
  performance_mode = "generalPurpose"
  #throughput_mode = "bursting"
  throughput_mode = "provisioned"
  provisioned_throughput_in_mibps = "8"
  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = local.tags
}

module "efs_access_point" {
  source = "app.terraform.io/pgconsulting/efs-access-point/aws"
  version = "1.0.0"
  tags = local.tags
  file_system_id = module.efs_file_system.id
  root_directory = { 
    path = join("",["/",local.name])
    }
  creation_info = {
      owner_gid = "1000"
      owner_uid = "1000"
      permissions = "755"
      }
  posix_user = {
    uid = "1000"
    gid = "1000"
  }
}

module "efs_mount_target_a" {
  source = "app.terraform.io/pgconsulting/efs-mount-target/aws"
  version = "1.0.0"
  file_system_id = module.efs_file_system.id
  subnet_id = data.aws_subnets.private.ids[0]
  security_groups = [module.aws_efs_sg.id]
}

module "efs_mount_target_b" {
  source = "app.terraform.io/pgconsulting/efs-mount-target/aws"
  version = "1.0.0"
  file_system_id = module.efs_file_system.id
  subnet_id = data.aws_subnets.private.ids[1]
  security_groups = [module.aws_efs_sg.id]
}

module "efs_mount_target_c" {
  source = "app.terraform.io/pgconsulting/efs-mount-target/aws"
  version = "1.0.0"
  file_system_id = module.efs_file_system.id
  subnet_id = data.aws_subnets.private.ids[2]
  security_groups = [module.aws_efs_sg.id]
}

module "efs-bkp-policy" {
  source = "app.terraform.io/pgconsulting/efs-backup-policy/aws"
  version = "1.0.0"
  file_system_id = module.efs_file_system.id
  status = "ENABLED"
}
