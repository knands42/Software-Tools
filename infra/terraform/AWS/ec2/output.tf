output "key_name" {
  value = aws_key_pair.ec2_key_pair.key_name
}

output "ec2_private_ip" {
  value = aws_instance.private.private_ip
}

output "ec2_public_ip" {
  value = aws_instance.public.public_ip
}
