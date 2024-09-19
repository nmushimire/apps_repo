# Creating vpc
resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    name = "Terraform-vpc"
    env = "dev"
    Team = "DevOps"
  }
}
# Creating internet gataway
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
}
# Creating Public subnet
resource "aws_subnet" "public1" {
  availability_zone = "us-east-1a"
  cidr_block = "192.168.1.0/24"
  vpc_id = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  tags = {
    name = "public-subnet-1"
    env = "dev"

  }
}
# Creating Public subnet
resource "aws_subnet" "public2" {
  availability_zone = "us-east-1b"
  cidr_block = "192.168.2.0/24"
  vpc_id = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  tags = {
    name = "public-subnet-2"
    env = "dev"

  }
}
 #Creating Private subnet
resource "aws_subnet" "private1" {
  availability_zone = "us-east-1a"
  cidr_block = "192.168.3.0/24"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    name = "private-subnet-1"
    env = "dev"

  }
}
# Creating Private subnet
resource "aws_subnet" "private2" {
  availability_zone = "us-east-1b"
  cidr_block = "192.168.4.0/24"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    name = "private-subnet-2"
    env = "dev"

  }
}
# Creating Elastic ip and Nat gateway
resource "aws_eip" "eip" {
}
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public1.id
}
# Creating route-table-public
resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.vpc1.id
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw1.id
  }
}
# Creating route table-private
resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.vpc1.id
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat1.id
  }
}

# Subnet association
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpublic.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpublic.id
}
