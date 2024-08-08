
resource "aws_security_group" "allow_tls" {
  vpc_id      = aws_vpc.main.id
  name        = "allow_tls"
  description = "for EC2 "
  
  dynamic "ingress" {
     for_each = [22,80]    ## you can add multiple port here
     iterator = port 
     
   content {
   from_port = port.value
   to_port = port.value
   protocol = "tcp"
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
    Name = "MYSGTF"
  }
}
