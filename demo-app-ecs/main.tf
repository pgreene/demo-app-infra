module "aws_iam_role_ex" {
  source = "app.terraform.io/pgconsulting/iam-role/aws"
  version = "1.0.0"
  name = join("-",[local.name,"ex-ir"])
  assume_role_policy = file("${path.module}/files/assume-role-execution-policy.json")
  tags = local.tags
}

module "aws_iam_policy_ex" {
  source = "app.terraform.io/pgconsulting/iam-policy/aws"
  version = "1.0.0"
  name = join("-",[local.name,"ex-ip"])
  policy_json = file("${path.module}/files/role-execution-policy.json")

}

module "aws_iam_role_policy_attach_ex" {
  source = "app.terraform.io/pgconsulting/iam-role-policy-attach/aws"
  version = "1.0.0"
  role_name = module.aws_iam_role_ex.name
  policy_arn = module.aws_iam_policy_ex.arn
}

module "aws_iam_role" {
  source = "app.terraform.io/pgconsulting/iam-role/aws"
  version = "1.0.0"
  name = join("-",[local.name,"ir"])
  assume_role_policy = file("${path.module}/files/assume-role-policy.json")
  tags = local.tags
}

module "aws_iam_policy" {
  source = "app.terraform.io/pgconsulting/iam-policy/aws"
  version = "1.0.0"
  name = join("-",[local.name,"ip"])
  policy_json = file("${path.module}/files/role-policy.json")
}

module "aws_iam_role_policy_attach" {
  source = "app.terraform.io/pgconsulting/iam-role-policy-attach/aws"
  version = "1.0.0"
  role_name = module.aws_iam_role.name
  policy_arn = module.aws_iam_policy.arn
}

module "cloudwatch_log_group" {
  source = "app.terraform.io/pgconsulting/cloudwatch-log-group/aws"
  version = "1.0.0"
  name = local.name
  retention_in_days = 30
  tags = local.tags
}

module "ecs_cluster" {
  source = "app.terraform.io/pgconsulting/ecs-cluster/aws"
  version = "1.0.4"
  name = local.name
  #capacity_providers = "FARGATE_SPOT"
  #capacity_providers = ["FARGATE"]
  tags = local.tags
  #use_configuration = false
  #service_connect_defaults = false
  #setting = false
}

module "ecs_service" {
  source = "app.terraform.io/pgconsulting/ecs-service/aws"
  version = "1.0.0"
  name = join("-",[local.name,"service"])
  cluster = module.ecs_cluster.id
  task_definition = module.ecs_task_definition.arn
  desired_count = 1
  enable_execute_command = true
  #iam_role = module.aws_iam_role.arn
  health_check_grace_period_seconds = 300
  deployment_minimum_healthy_percent = 0
  load_balancer = {
    target_group_arn = module.aws_lb_target_group_80.arn
    container_name = "demo-app"
    container_port = local.port
    elb_name = ""
  }
  network_configuration = {
    subnets = [data.aws_subnets.private.ids[0],data.aws_subnets.private.ids[1],data.aws_subnets.private.ids[2]]
    security_groups = [module.aws_app_sg.id]
    assign_public_ip = true
  }
  launch_type = "FARGATE"
  platform_version = "LATEST"
  #wait_for_steady_state = true
  service_registries = {
  }
  registry_arn = module.sd_service.arn
  #port = local.agent_port
  container_name = "demo-app"
  tags = local.tags
  propagate_tags = "TASK_DEFINITION"
}

module "aws_alb" {
  source = "app.terraform.io/pgconsulting/lb/aws"
  version = "1.0.0"
  name = local.name
  security_groups = [module.aws_sg.id]
  load_balancer_type = "application"
  internal = false
  subnets = [data.aws_subnets.public.ids[0],data.aws_subnets.public.ids[1],data.aws_subnets.public.ids[2]]
  idle_timeout = 60
  enable_http2 = true
  //role_arn = module.aws_iam_role.iam_role_arn
  # access_logs_enabled = true
  # access_logs_s3bucket = "BUCKET-NAME"
  tags = local.tags
}

module "aws_lb_target_group_80" {
  source = "app.terraform.io/pgconsulting/lb-target-group/aws"
  version = "1.0.0"
  name = local.name
  vpc_id = data.aws_vpc.selected.id
  port = "80"
  protocol = "HTTP"
  target_type = "ip"
  deregistration_delay = 10
  health_check = { 
    health_check_enabled = true
    health_check_interval = 30
    health_check_path = "/"
    health_check_port = "traffic-port"
    health_check_protocol = "HTTP"
    health_check_timeout = 3
    health_check_healthy_threshold = 3
    health_check_unhealthy_threshold = 2
    health_check_matcher = "200-399"
  }
  tags = local.tags
}

module "aws_lb_listener_forward_80to80" {
  source = "app.terraform.io/pgconsulting/lb-listener/aws"
  version = "1.0.0"
  port = "80"
  protocol = "HTTP"
  default_action_type = "forward"
  load_balancer_arn = module.aws_alb.arn
  target_group_arn = module.aws_lb_target_group_80.arn
}

module "aws_lb_listener_forward_443to80" {
  source = "app.terraform.io/pgconsulting/lb-listener/aws"
  version = "1.0.0"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  #ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = data.aws_acm_certificate.url.arn
  default_action_type = "forward"
  load_balancer_arn = module.aws_alb.arn
  target_group_arn = module.aws_lb_target_group_80.arn
}

module "aws_route53_ipv4" {
  source = "app.terraform.io/pgconsulting/route53-record/aws"
  version = "1.0.1"
  name = "demo-app"
  zone_id = data.aws_route53_zone.selected.zone_id
  type = "A"
  alias = {
  }
  alias_zone_id = module.aws_alb.zone_id
  alias_evaluate_target_health = false
  alias_name = module.aws_alb.dns_name
}