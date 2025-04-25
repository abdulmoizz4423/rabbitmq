# RabbitMQ
data "aws_security_group" "rabbitmq" {
  filter {
    name   = "group-name"
    values = ["rabbitmq-sg"]
  }
}

resource "aws_ecs_service" "rabbitmq" {
  name            = "rabbitmq-tf"
  cluster         = data.aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.rabbitmq_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [data.aws_subnet.main.id, data.aws_subnet.secondary.id]
    security_groups  = [data.aws_security_group.rabbitmq.id]
    assign_public_ip = true
  }

  tags = {
    Name = "rabbitmq-tf"
  }
}