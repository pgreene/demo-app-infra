module "ecs_task_definition" {
  source = "app.terraform.io/pgconsulting/ecs-task-definition/aws"
  version = "1.0.0"
  family = local.name
  tags = local.tags
  
  container_definitions = jsonencode([
    {
      #name = join("-",[local.env,local.prefix])
      name = "demo-app"
      image = "358665735850.dkr.ecr.ca-central-1.amazonaws.com/dev-demo-app-ecr:latest"
      #image = join("",local.account_id,".dkr.ecr.",local.region,".amazonaws.com/dev-demo-app:latest") 
      environment = [
        {
          name = "AWS_REGION" 
          value = local.region
        },
        {
          name = "ECS_AGENT_CLUSTER" 
          value = module.ecs_cluster.id
        },
        {
          name = "APP_URL" 
          value = "https://dev-demo-app.pgconsulting.com"
        },
        {
          name = "LOG_GROUP_NAME" 
          value = module.cloudwatch_log_group.name
        }
      ]
      #secrets = [
      #  {
      #    name = "APP_PASSWORD" 
      #    valuefrom = module.ssm_parameter.name
      #  }
      #]
      linuxParameters = {
        initProcessEnabled = true
      }      
      logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group = module.cloudwatch_log_group.name
              awslogs-region = local.region
              awslogs-stream-prefix = local.name
            }
          }
      mountPoints = [
        {
          readOnly = null,
          containerPath = join("/",["/var",local.name])
          sourceVolume = local.name
        }
      ]
      portMappings = [
        {
          containerPort = 80
          #protocol = "tcp"
          #hostPort = 8080
        },
      ]
    }
  ])

  execution_role_arn = module.aws_iam_role_ex.arn
  task_role_arn = module.aws_iam_role.arn
  network_mode = "awsvpc"
  cpu = 2048
  memory = 8192
  requires_compatibilities = [
        "EC2",
        "FARGATE"
      ]
  volume = {
    name = local.name
    host_path = ""
  }
  efs_volume_configuration = {
    file_system_id = module.efs_file_system.id
    root_directory = "/"
    transit_encryption = "ENABLED"
    transit_encryption_port = null
  }
  authorization_config = {
    access_point_id = module.efs_access_point.id
    iam = "ENABLED"
  }

}