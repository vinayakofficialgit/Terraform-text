resource "aws_instance" "server" {
   ami           = "ami-032346ab877c418af"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.pub.id
  availability_zone = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data =  "${file("nginx.sh")}"
   
 

              

  tags = {
    Name = "terraformec2"
  }
}

