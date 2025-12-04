data "aws_availability_zones" "private_zones" {
  exclude_names = var.public_availability_zones
}
