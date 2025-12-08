resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.prefix}-${var.env}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "private" {
  ami           = "ami-0f00d706c4a80fd93"
  instance_type = "t2.nano"
  key_name      = aws_key_pair.ec2_key_pair.key_name

  subnet_id              = var.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg_private.id]
  # iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello from Terraform EC2</h1>" > /var/www/html/index.html
                EOF

  tags = {
    Name = "${var.prefix}-${var.env}-ec2-private-instance"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

resource "aws_instance" "public" {
  ami           = "ami-0f00d706c4a80fd93"
  instance_type = "t2.nano"
  key_name      = aws_key_pair.ec2_key_pair.key_name

  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg_public.id]
  # iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello from Terraform EC2</h1>" > /var/www/html/index.html
                EOF

  tags = {
    Name = "${var.prefix}-${var.env}-ec2-public-instance"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}
