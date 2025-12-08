# Private Security Group
resource "aws_security_group" "ec2_sg_private" {
  name        = "${var.prefix}-${var.env}-ec2-sg-private"
  description = "Security group for EC2 instances privately available"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-${var.env}-ec2-sg-private"
  }
}

# Private Security Group Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "private_ssh" {
  security_group_id = aws_security_group.ec2_sg_private.id
  description       = "SSH access from allowed IP"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.allowed_ip
}

resource "aws_vpc_security_group_ingress_rule" "private_http" {
  security_group_id = aws_security_group.ec2_sg_private.id
  description       = "HTTP access from allowed IP"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.allowed_ip
}

# Private Security Group Egress Rules
resource "aws_vpc_security_group_egress_rule" "private_http_out" {
  security_group_id = aws_security_group.ec2_sg_private.id
  description       = "Allow HTTP outbound"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "private_https_out" {
  security_group_id = aws_security_group.ec2_sg_private.id
  description       = "Allow HTTPS outbound"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Public Security Group
resource "aws_security_group" "ec2_sg_public" {
  name        = "${var.prefix}-${var.env}-ec2-sg-public"
  description = "Security group for EC2 instances publicly available"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-${var.env}-ec2-sg-public"
  }
}

# Public Security Group Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "public_ssh" {
  security_group_id = aws_security_group.ec2_sg_public.id
  description       = "SSH access from allowed IP"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.allowed_ip
}

resource "aws_vpc_security_group_ingress_rule" "public_http" {
  security_group_id = aws_security_group.ec2_sg_public.id
  description       = "HTTP access from allowed IP"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.allowed_ip
}

# Public Security Group Egress Rules
resource "aws_vpc_security_group_egress_rule" "public_http_out" {
  security_group_id = aws_security_group.ec2_sg_public.id
  description       = "Allow HTTP outbound"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_https_out" {
  security_group_id = aws_security_group.ec2_sg_public.id
  description       = "Allow HTTPS outbound"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}
