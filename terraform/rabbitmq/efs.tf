resource "aws_efs_file_system" "rabbitmq-fs" {
  creation_token   = "rabbitmq-efs"
  performance_mode = "generalPurpose"
  encrypted        = true

  tags = {
    Name = "rabbitmq-efs"
  }
}