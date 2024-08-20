resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.prefix}-${var.env}-rtb-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-${var.env}-rtb-public"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private_zones)
  subnet_id      = aws_subnet.private_zones[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_zones)
  subnet_id      = aws_subnet.public_zones[count.index].id
  route_table_id = aws_route_table.public.id
}