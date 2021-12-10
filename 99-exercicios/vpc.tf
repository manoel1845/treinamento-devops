resource "aws_vpc" "main" {
  cidr_block          = "10.20.0.0/16"
  instance_tenancy    = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-turma3-mineiro"
  }
}

resource "aws_subnet" "subnet-az-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mineiro_subnet-az-a"
  }
}

resource "aws_subnet" "subnet-az-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.64.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "mineiro_subnet-az-b"
  }
}

resource "aws_subnet" "subnet-az-c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.128.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "mineiro_subnet-az-c"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route-table-mineiro"
  }
}

resource "aws_route_table_association" "route_table-association-a" {
  subnet_id      = aws_subnet.subnet-az-a.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_route_table_association" "route_table-association-b" {
  subnet_id      = aws_subnet.subnet-az-b.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table-association-c" {
  subnet_id      = aws_subnet.subnet-az-c.id
  route_table_id = aws_route_table.route_table.id
}
