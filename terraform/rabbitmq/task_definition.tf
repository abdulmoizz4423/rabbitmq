# RabbitMQ

data "aws_iam_role" "ecs_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "rabbitmq_task" {
  family                   = "rabbitmq-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = data.aws_iam_role.ecs_role.arn
  task_role_arn            = data.aws_iam_role.ecs_role.arn

  container_definitions = jsonencode([
    {
      name              = "rabbitmq"
      image             = "084828598848.dkr.ecr.us-east-1.amazonaws.com/rabbitmq:latest"
      cpu               = 1024
      memory            = 3072
      memoryReservation = 1024
      portMappings = [
        {
          containerPort = 5672
          hostPort      = 5672
          protocol      = "tcp"
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/rabbitmq-td"
          awslogs-region        = "us-east-1"
          awslogs-create-group  = "true"
          awslogs-stream-prefix = "ecs"
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
        }
      }
      environment = []
      mountPoints = [
        {
          sourceVolume  = "rabbitmq"
          containerPath = "/mnt/efs"
          readOnly      = false
        }
      ]
    }
  ])

  volume {
    name = "rabbitmq"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.rabbitmq-fs.id
      root_directory = "/"
    }
  }

  tags = {
    "Environment" = "production"
  }
}