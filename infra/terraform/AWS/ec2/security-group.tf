resource "aws_security_group" "ec2_sg" {
    name = "${var.prefix}-${var.env}-ec2-sg"
    description = "Security group for EC2 instances"
    vpc_id = var.vpc_id

    ingress = {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["45.94.208.62/32"]
    }

    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}