module "rds_db_subnet_group" {
  source  = "app.terraform.io/pgconsulting/db-subnet-group/aws"
  version = "1.0.0"
  name = local.name
  subnet_ids = [data.aws_subnets.private.ids[0],data.aws_subnets.private.ids[1],data.aws_subnets.private.ids[2]]
  tags = local.tags
}

module "kms" {
  source  = "app.terraform.io/pgconsulting/kms/aws"
  version = "1.0.1"
  description = "used for demo-app database"
  kms_is_enabled = true
  enable_key_rotation = true
  deletion_window_in_days = 7
  tags = local.tags
}

module "aws_sg_db" {
  source  = "app.terraform.io/pgconsulting/security-group/aws"
  version = "1.0.0"
  name = local.name
  vpc_id = data.aws_vpc.selected.id
  tags = local.tags
}

module "aws_sg_rule_db3306_ingress" {
  source  = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "ingress"
  cidr_blocks = [data.aws_vpc.selected.cidr_block]
  from_port = "3306"
  to_port = "3306"
  protocol = "tcp"
  security_group_id = module.aws_sg_db.id
}

module "aws_sg_rule_db3306_egress" {
  source  = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "egress"
  cidr_blocks = [data.aws_vpc.selected.cidr_block]
  from_port = "3306"
  to_port = "3306"
  protocol = "tcp"
  security_group_id = module.aws_sg_db.id
}

module "aws_rds_cluster_parameter_group" {
  source  = "app.terraform.io/pgconsulting/rds-cluster-parameter-group/aws"
  version = "1.0.0"
  name = local.name
  family = "aurora-mysql8.0"
  max_connections = "10000"
  slow_query_log = "1"
  log_queries_not_using_indexes = "1"
  wait_timeout = "300"
  tags = local.tags
}

module "kms_ssm" {
  source  = "app.terraform.io/pgconsulting/kms/aws"
  version = "1.0.1"
  description = "used for database secret"
  kms_is_enabled = true
  enable_key_rotation = true
  deletion_window_in_days = 7
  tags = local.tags
}

module "random_password" {
  source = "git::https://github.com/pgreene/random-password?ref=1.0.2"
  #source = "git@github.com:pgreene/random-password.git?ref=v1.0.0"
  length = 24
}

module "ssm_parameter" {
  source  = "app.terraform.io/pgconsulting/ssm-parameter/aws"
  version = "1.0.0"
  name = local.name
  value = module.random_password.result
  type = "SecureString"
  key_id = module.kms_ssm.id
  tags = local.tags
}

module "aws_rds_cluster_aurora_serverless" {
  source  = "app.terraform.io/pgconsulting/rds-cluster/aws"
  version = "1.0.0"
  #name = join("-",[module.label.id])
  cluster_identifier = local.name
  database_name = "demoappdb"
  apply_immediately = true
  vpc_security_group_ids = [module.aws_sg_db.id]
  db_subnet_group_name = module.rds_db_subnet_group.id
  storage_encrypted = true
  kms_key_id = module.kms.arn
  db_cluster_parameter_group_name = module.aws_rds_cluster_parameter_group.id
  engine_mode = "provisioned"
  engine = "aurora-mysql"
  master_username = local.db_username
  master_password = module.ssm_parameter.value
  deletion_protection = false # change to true for PROD
  serverlessv2_scaling_configuration = {}
    serverlessv2_scaling_configuration_max_capacity = 8
    serverlessv2_scaling_configuration_min_capacity = 1
  //enabled_cloudwatch_logs_exports = ["audit", "error"]
  //scaling_configuration_timeout_action = "ForceApplyCapacityChange" 
  skip_final_snapshot = false
  final_snapshot_identifier = join("-",[local.env,local.prefix,"delete"])
  backup_retention_period = 30
  preferred_backup_window = null
  preferred_maintenance_window = null
  availability_zones = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1],data.aws_availability_zones.available.names[2]]
  tags = local.tags
}
