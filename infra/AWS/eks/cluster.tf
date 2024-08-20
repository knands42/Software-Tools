resource "aws_iam_role" "eks" {
  name               = "${var.prefix}-${var.env}-${var.eks_cluster_name}-eks-role"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "cluster" {
  name                      = "${var.prefix}-${var.env}-${var.eks_cluster_name}"
  version                   = var.eks_version
  role_arn                  = aws_iam_role.eks.arn
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = var.private_subnet_ids
  }

  access_config {
    authentication_mode                          = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks
  ]
}