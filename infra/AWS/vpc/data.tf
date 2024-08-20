data "aws_availability_zones" "available" {
  exclude_names = var.public_availability_zones
}
