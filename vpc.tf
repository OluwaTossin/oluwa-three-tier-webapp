provider "aws" {
  region = "us-west-2"  # Ensure this is your preferred region
}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-three-tier-webapp-oluwa"
  }
}

# Internet Gateway for public access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "igw-three-tier-webapp-oluwa"
  }
}

# Public Subnet for ALB (Frontend)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-oluwa"
  }
}

# Private Subnet for Backend (EC2)
resource "aws_subnet" "private_backend_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-backend-subnet-oluwa"
  }
}

# Private Subnet for Database (future use)
resource "aws_subnet" "private_database_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "private-database-subnet-oluwa"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "public-route-table-oluwa"
  }
}

# Associate Public Subnet with the Route Table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

# NAT Gateway for Private Subnets (Backend and Database)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "nat-gateway-oluwa"
  }
}

# Private Route Table with NAT for Backend and Database Subnets
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  
  tags = {
    Name = "private-route-table-oluwa"
  }
}

# Associate Backend Subnet with the Private Route Table
resource "aws_route_table_association" "private_backend_association" {
  subnet_id      = aws_subnet.private_backend_subnet.id
  route_table_id = aws_route_table.private_route.id
}

# Associate Database Subnet with the Private Route Table (optional for future use)
resource "aws_route_table_association" "private_database_association" {
  subnet_id      = aws_subnet.private_database_subnet.id
  route_table_id = aws_route_table.private_route.id
}
