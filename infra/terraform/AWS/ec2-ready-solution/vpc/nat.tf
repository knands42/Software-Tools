# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway_redundancy ? length(var.availability_zones) : 1
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-nat-eip-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateways for high availability
resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway_redundancy ? length(var.availability_zones) : 1
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_zones[count.index].id

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-nat-gateway-${count.index + 1}"
    AZ   = var.availability_zones[count.index]
  })

  depends_on = [aws_internet_gateway.igw]
}