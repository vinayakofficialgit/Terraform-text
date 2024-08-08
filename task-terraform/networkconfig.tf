resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "pub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "Pub Subnet"
  }
}

resource "aws_subnet" "pvt" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"


  tags = {
    Name = "pvt Subnet"
  }
}




resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Pub RT Table"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.pub.id
}
