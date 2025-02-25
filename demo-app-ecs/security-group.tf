# ------------------------------------------------------ #
# --- Security Group for the Load Balancer ------------- #
# ------------------------------------------------------ #

module "aws_sg" {
  source = "app.terraform.io/pgconsulting/security-group/aws"
  version = "1.0.0"
  name = local.name
  vpc_id = data.aws_vpc.selected.id
  tags = local.tags
}

module "aws_sg_rule_80_ingress" {
  source = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  from_port = local.port
  to_port = local.port
  protocol = "tcp"
  security_group_id = module.aws_sg.id
}

module "aws_sg_rule_443_ingress" {
  source = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  from_port = local.secure_port
  to_port = local.secure_port
  protocol = "tcp"
  security_group_id = module.aws_sg.id
}

module "aws_sg_rule_all_egress" {
  source = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "egress"
  description = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = module.aws_app_sg.id
  ipv6_cidr_blocks = ["::/0"]
  from_port = "0"
  to_port = "0"
  protocol = "all"
  security_group_id = module.aws_sg.id
}

# ------------------------------------------------------ #
# --- Security Group for the EFS ----------------------- #
# ------------------------------------------------------ #

module "aws_efs_sg" {
  source = "app.terraform.io/pgconsulting/security-group/aws"
  version = "1.0.0"
  name = join("-",[local.env,local.prefix,"efs-sg"])
  vpc_id = data.aws_vpc.selected.id
  tags = local.tags
}

module "aws_efs_sg_rule_2049_ingress" {
  source = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "ingress"
  cidr_blocks = [data.aws_vpc.selected.cidr_block]
  ipv6_cidr_blocks = ["::/0"]
  from_port = "2049"
  to_port = "2049"
  protocol = "tcp"
  security_group_id = module.aws_efs_sg.id
}

module "aws_efs_sg_rule_all_egress" {
  source = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "egress"
  description = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  from_port = "0"
  to_port = "0"
  protocol = "all"
  security_group_id = module.aws_efs_sg.id
}

# ------------------------------------------------------ #
# --- Security Group for App  -------------------------- #
# ------------------------------------------------------ #

module "aws_app_sg" {
  source = "app.terraform.io/pgconsulting/security-group/aws"
  version = "1.0.0"
  name = join("-",[local.name,"app-sg"])
  vpc_id = data.aws_vpc.selected.id
  tags = local.tags
}

module "aws_app_sg_rule_80_ingress" {
  source = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "ingress"
  #cidr_blocks = [data.aws_vpc.selected.cidr_block]
  source_security_group_id = module.aws_sg.id
  from_port = local.port
  to_port = local.port
  protocol = "tcp"
  security_group_id = module.aws_app_sg.id
}


module "aws_app_sg_rule_all_egress" {
  source = "app.terraform.io/pgconsulting/security-group-rule/aws"
  version = "1.0.0"
  type = "egress"
  description = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = module.aws_sg.id
  from_port = "0"
  to_port = "0"
  protocol = "all"
  security_group_id = module.aws_app_sg.id
}
