// Create dynamic subnets for all availability zones
resource "aws_subnet" "private_zones" {
    vpc_id                  = aws_vpc.main.id
    count                   = length(data.aws_availability_zones.private_zones.names)
    availability_zone       = data.aws_availability_zones.private_zones.names[count.index]
    cidr_block              = "10.0.${count.index + 100}.0/24"
    
    tags = {
        Name = "${var.prefix}-${var.env}-private-${count.index}"
        "kubernetes.io/role/internal-elb" = "1" # Internal ELB if want to expose the service internally
        "kubernetes.io/cluster/${var.prefix}-${var.env}" = "owned"
    }
}

resource "aws_subnet" "public_zones" {
    vpc_id                  = aws_vpc.main.id
    count                   = length(var.public_availability_zones)
    availability_zone       = var.public_availability_zones[count.index]
    cidr_block              = "10.0.${count.index}.0/24"

    map_public_ip_on_launch = true

    tags = {
        Name = "${var.prefix}-${var.env}-private-${count.index}"
        "kubernetes.io/role/elb" = "1" # 
        "kubernetes.io/cluster/${var.prefix}-${var.env}" = "owned" # 
  }
}