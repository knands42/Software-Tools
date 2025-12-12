# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-rtb-public"
    Type = "Public"
  })
}

# Private route tables (one per AZ for NAT Gateway redundancy)
resource "aws_route_table" "private" {
  count  = var.enable_nat_gateway_redundancy ? length(var.availability_zones) : 1
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-rtb-private-${count.index + 1}"
    Type = "Private"
    AZ   = var.availability_zones[count.index]
  })
}

# S3 VPC Endpoint for private subnets
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-s3-endpoint"
  })
}

# Public subnet route table associations
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_zones)
  subnet_id      = aws_subnet.public_zones[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private subnet route table associations
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private_zones)
  subnet_id      = aws_subnet.private_zones[count.index].id
  route_table_id = var.enable_nat_gateway_redundancy ? aws_route_table.private[count.index].id : aws_route_table.private[0].id
}