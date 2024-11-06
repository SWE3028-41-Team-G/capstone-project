resource "aws_instance" "database" {
  ami                         = "ami-0c28dbbd4ed200038"
  instance_type               = "t4g.small"
  subnet_id                   = aws_subnet.private_1.id
  key_name                    = "skkudm-key-pair"
  vpc_security_group_ids      = [aws_security_group.ec2.id, data.aws_security_group.ssh-allow.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = templatefile("${path.module}/databases-docker.sh.tpl", { postgres_password = var.postgres_password })

  tags = {
    Name = "EC2 Instance for Postgres and Redis"
  }
}
