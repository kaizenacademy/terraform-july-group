provider aws {
    region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
    tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block1
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = var.ip

  tags = {
    Name = "Main1"
  }
}

resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block2
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main2"
  }
}

resource "aws_subnet" "main3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block3
  availability_zone = "${var.region}c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main3"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.main1.id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "a3" {
  subnet_id      = aws_subnet.main3.id
  route_table_id = aws_route_table.example.id
}

resource "aws_eip" "nat_eip" {
  instance = null
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.main1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "example1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "private-main1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.101.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "Private-Main1"
  }
}

resource "aws_subnet" "private-main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.102.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "Private-Main2"
  }
}

resource "aws_subnet" "private-main3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.103.0/24"
  availability_zone = "${var.region}c"

  tags = {
    Name = "Private-Main3"
  }
}

resource "aws_route_table_association" "b1" {
  subnet_id      = aws_subnet.private-main1.id
  route_table_id = aws_route_table.example1.id
}

resource "aws_route_table_association" "b2" {
  subnet_id      = aws_subnet.private-main2.id
  route_table_id = aws_route_table.example1.id
}

resource "aws_route_table_association" "b3" {
  subnet_id      = aws_subnet.private-main3.id
  route_table_id = aws_route_table.example1.id
}