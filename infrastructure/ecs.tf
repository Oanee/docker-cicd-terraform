resource "aws_cloudwatch_log_group" "ecs_backend" {
  name              = "/ecs/backend-cluster"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

locals {
  api_url   = "https://${aws_cloudfront_distribution.frontend_cdn.domain_name}"
  mongo_uri = mongodbatlas_advanced_cluster.cluster.connection_strings.standard_srv

  backend_env = [
    {
      name  = "MONGO_URI"
      value = local.mongo_uri
    },
    {
      name  = "MONGO_USER"
      value = var.mongo_username
    },
    {
      name  = "MONGO_PASS"
      value = var.mongo_password
    },
    {
      name  = "MONGO_DB_NAME"
      value = var.mongo_db_name
    },
    {
      name  = "PORT"
      value = tostring(var.backend_port)
    },
    {
      name  = "SECRET_JWT_KEY"
      value = var.secret_jwt_key
    },
    {
      name  = "NODE_ENV"
      value = var.node_env
    },
    {
      name  = "API_URL"
      value = local.api_url
    }
  ]
}

resource "aws_ecs_cluster" "main" {
  name = "backend-cluster"
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = "oanee/backend:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.backend_port
          hostPort      = var.backend_port
        }
      ]

      environment = local.backend_env

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend-cluster"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend" {
  name                              = "backend-service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.backend.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 60

  force_new_deployment = true

  network_configuration {
    subnets          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups  = [aws_security_group.backend_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_tg.arn
    container_name   = "backend-container"
    container_port   = var.backend_port
  }
}
