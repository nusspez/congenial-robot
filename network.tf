# create VPC 
resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"


    tags = {
      "Name" = var.vpc_name
    }
  
}

# Internet gateway for public subnet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "Name" = "Terraform internet Gateway"
  }
}

# Eastic-IP for NAT

resource "aws_eip" "nat_elastic_ip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.internet_gateway
  ]

}

# NAT

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_elastic_ip.id
  subnet_id = element(aws_subnet.public_subnet.*.id, 0)
  tags = {
    "Name" = "nat"
  }
}

# public_subnet

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true


  tags = {
    Name        = "${element(var.availability_zones, count.index)}-public-subnet"
    name_variable = var.name_public_subnet
  }
}

# private subnet

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.main_vpc.id
  cidr_block              = "10.0.${length(data.aws_availability_zones.available.names) + count.index}.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  
  tags = {
    "Name" = "${element(var.availability_zones, count.index)}-private-subnet"
    name_variable = var.name_private_subnet
  }
}


# Routing tables to route traffic for private subnet

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "Name" = "Terraform-private-route-table"
  }
}

# Routing tables to route traffic for Public Subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.internet_gateway.id
 }
  tags = {
    "Name" = "Terraform-public-route-table"
  }
}

# Route for Internet Gateway

resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
}

# route for NAT

resource "aws_route" "private_nat_gateway" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# router table associations for public and private subnets

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidr)
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets_cidr)
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}