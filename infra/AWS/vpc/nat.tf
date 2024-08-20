resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        Name = "${var.prefix}-${var.env}-nat"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_zones[0].id

    tags = {
        Name = "${var.prefix}-${var.env}-nat"
    }

    depends_on = [aws_internet_gateway.igw]
}