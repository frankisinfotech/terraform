#--------------
# VPC Definition
#--------------
resource "aws_vpc" "saha_vpc" {
  cidr_block           = "172.10.0.0/16"
  instance_tenancy     = "default"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name               = "saha-sandbox-vpc"
  }
}

#-------------
# Data for AZ
#-------------
data "aws_availability_zones" "azs" {
  state = "available"
}


#------------------------
# Public Subnet Settings 
#------------------------
# Create Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = 3

  vpc_id                  = aws_vpc.saha_vpc.id
  cidr_block              = "172.10.${count.index + 1}.0/24"
  availability_zone       = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "saha-sandbox-public-subnet-${count.index + 1}"
  }
}

#-------------------------
# Private Subnet Settings 
#-------------------------
resource "aws_subnet" "private_subnet" {
  count                   = 3

  vpc_id                  = aws_vpc.saha_vpc.id
  cidr_block              = "172.10.${count.index + 4}.0/24"
#  availability_zone       = "var.availability_zones.{count.index}"
  availability_zone       = element(var.availability_zones, count.index)

  map_public_ip_on_launch = false

  tags = {
    Name = "saha-sandbox-private-subnet-${count.index + 1}"
  }
}


#-----------------------------
# Public Route Table Settings
#-----------------------------
resource "aws_route_table" "saha-sandbox_rt" {
  vpc_id                  = aws_vpc.saha_vpc.id

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.saha_igw.id
  }

  tags = {
    Name                  = "saha-sandbox-public-rt"
  }
}


#-----------------------------
# Private Route Table Settings
#-----------------------------
resource "aws_route_table" "saha-sandbox_private_rt" {
  vpc_id                  = aws_vpc.saha_vpc.id


  tags = {
    Name                  = "saha-sandbox-private-rt"
  }
}


#--------------------------------
# Public Route Table Association 
#--------------------------------
resource "aws_route_table_association" "rt_a" {
  count                   = 3
  subnet_id               = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id          = element(aws_route_table.saha-sandbox_rt.*.id, count.index)
}


#---------------------------------
# Private Route Table Association 
#---------------------------------
resource "aws_route_table_association" "rt_b" {
  count                   = 3
  subnet_id               = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id          = element(aws_route_table.saha-sandbox_private_rt.*.id, count.index)
}



#-----------------
# Internet Gateway
#-----------------
resource "aws_internet_gateway" "saha_igw" {
  vpc_id                  = aws_vpc.saha_vpc.id

  tags = {
    Name                  = "saha-sandbox-igw"
  }
}


