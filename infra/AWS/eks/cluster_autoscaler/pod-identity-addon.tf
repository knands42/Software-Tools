resource "aws_eks_addon" "pod_identity" {
  cluster_name  = var.eks_cluster_fullname
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.2-eksbuild.2"
}