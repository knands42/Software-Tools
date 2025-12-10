output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_zones.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_zones.*.id
}
