resource "aws_security_group" "mysg" {
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [22, 80]   # Define multiple ports
    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls_sg"
  }
}

