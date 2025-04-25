# RabbitMQ

data "aws_iam_role" "ecs_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "rabbitmq_task" {
  family                   = "green-one"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = data.aws_iam_role.ecs_role.arn
  task_role_arn            = data.aws_iam_role.ecs_role.arn

  container_definitions = jsonencode([{
    name  = "gree-one"
    image = "084828598848.dkr.ecr.us-east-1.amazonaws.com/rabbitmq:latest"
    cpu   = 0
    portMappings = [
      {
        name          = "gree-one-15672-tcp"
        containerPort = 15672
        hostPort      = 15672
        protocol      = "tcp"
        appProtocol   = "http"
      },
      {
        name          = "gree-one-5672-tcp"
        containerPort = 5672
        hostPort      = 5672
        protocol      = "tcp"
        appProtocol   = "http"
      }
    ]
    essential = true
    environment = [
      {
        name  = "RABBITMQ_DEFAULT_PASS"
        value = "password"
      },
      {
        name  = "RABBITMQ_DEFAULT_USER"
        value = "user"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/green-one"
        awslogs-region        = "us-east-1"
        awslogs-create-group  = "true"
        awslogs-stream-prefix = "ecs"
        mode                  = "non-blocking"
        max-buffer-size       = "25m"
      }
    }
    mountPoints = []
  }])

  volume {
    name = "green-one"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.rabbitmq-fs.id
      root_directory = "/"
    }
  }

  tags = {
    "Environment" = "production"
  }
}