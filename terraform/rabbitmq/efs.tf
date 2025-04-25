resource "aws_efs_file_system" "rabbitmq-fs" {
  creation_token   = "rabbitmq-efs"
  performance_mode = "generalPurpose"
  encrypted        = true

  tags = {
    Name = "rabbitmq-efs"
  }
}

resource "aws_efs_mount_target" "rabbitmq_mt" {

  file_system_id = aws_efs_file_system.rabbitmq-fs.id
  subnet_id      = data.aws_subnet.main.id
}
