resource "aws_security_group" "ec2" {
  name        = "skkudm-sg-ec2"
  description = "Allow local access to PostgreSQL and Redis within VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
    description = "Allow local PostgreSQL access"
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
    description = "Allow local Redis access"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all outbound traffic"
  }

  tags = {
    Name = "skkudm-sg-ec2"
  }
}

data "aws_security_group" "ssh-allow" {
  id = "sg-0926f131881f41a2d"
}
