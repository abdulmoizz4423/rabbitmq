resource "aws_efs_file_system" "rabbitmq-fs" {
  creation_token   = "rabbitmq-efs"
  performance_mode = "generalPurpose"
  encrypted        = true

  tags = {
    Name = "rabbitmq-efs"
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id  = aws_efs_file_system.rabbitmq-fs.id
  subnet_id       = data.aws_subnet.main.id
  security_groups = [data.aws_security_group.rabbitmq.id]
}
