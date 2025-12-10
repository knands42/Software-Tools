resource "tls_private_key" "ec2_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.prefix}-${var.env}-ec2-key-pair"
  public_key = tls_private_key.ec2_key_pair.public_key_openssh
}

resource "local_file" "ec2_private_key" {
  content         = tls_private_key.ec2_key_pair.private_key_pem
  filename        = "${var.ssh_path}/${var.prefix}-${var.env}-ec2-key-pair.pem"
  file_permission = "0400"
}
