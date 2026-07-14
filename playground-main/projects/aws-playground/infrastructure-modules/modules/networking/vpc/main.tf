terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = var.vpc_name })
}

# Internet Gateway (for public subnets)
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}-igw" })
}

# Public subnets
resource "aws_subnet" "public" {
  for_each = { for idx, az in var.availability_zones : az => idx }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "${var.vpc_name}-public-${each.key}", Tier = "public" })
}

# Private subnets
resource "aws_subnet" "private" {
  for_each = { for idx, az in var.availability_zones : az => idx }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, each.value + length(var.availability_zones))
  availability_zone = each.key

  tags = merge(var.tags, { Name = "${var.vpc_name}-private-${each.key}", Tier = "private" })
}

# Elastic IPs for NAT gateways
resource "aws_eip" "nat" {
  for_each = toset(var.availability_zones)
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${var.vpc_name}-nat-eip-${each.key}" })
}

# NAT Gateways (one per AZ for HA)
resource "aws_nat_gateway" "this" {
  for_each = toset(var.availability_zones)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(var.tags, { Name = "${var.vpc_name}-nat-${each.key}" })
  depends_on = [aws_internet_gateway.this]
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}-rt-public" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private route tables (one per AZ so each AZ uses its own NAT gateway)
resource "aws_route_table" "private" {
  for_each = toset(var.availability_zones)

  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}-rt-private-${each.key}" })
}

resource "aws_route" "private_nat" {
  for_each = toset(var.availability_zones)

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
