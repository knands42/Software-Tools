# Public subnets across multiple availability zones
resource "aws_subnet" "public_zones" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.public_subnet_cidrs[count.index]

  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-public-${count.index + 1}"
    Type = "Public"
    AZ   = var.availability_zones[count.index]
  })
}

# Private subnets across multiple availability zones
resource "aws_subnet" "private_zones" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-private-${count.index + 1}"
    Type = "Private"
    AZ   = var.availability_zones[count.index]
  })
}