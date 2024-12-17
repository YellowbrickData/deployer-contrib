locals {
  subnet_cidrs = cidrsubnets(
    var.vpc_cidr,
    var.subnet_bits_primary,
    var.subnet_bits_secondary,
    var.subnet_bits_public
  )
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "${local.instance_name}-vpc"
    },
  local.tags)
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${local.instance_name}-igw"
    },
  local.tags)
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = merge(
    {
      Name = "${local.instance_name}-nat"
    },
  local.tags)
}

resource "aws_eip" "nat" {
  depends_on = [
    aws_internet_gateway.this
  ]
}

resource "aws_subnet" "primary" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.subnet_cidrs[0]
  availability_zone = var.primary_zone

  tags = merge(
    {
      Name    = "${local.instance_name}-primary"
      primary = "true"
    },
  local.tags)
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.subnet_cidrs[1]
  availability_zone = var.secondary_zone

  tags = merge(
    {
      Name = "${local.instance_name}-secondary"
    },
  local.tags)
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.subnet_cidrs[2]
  availability_zone       = var.primary_zone
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name   = "${local.instance_name}-public"
      public = "true"
    },
  local.tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${local.instance_name}-public"
    },
  local.tags)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${local.instance_name}-private"
    },
  local.tags)
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "primary" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "secondary" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.private.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids   = [aws_route_table.private.id]
  vpc_endpoint_type = "Gateway"

  tags = merge(
    {
      Name = "${local.instance_name}-s3-vpce"
    },
  local.tags)
}
