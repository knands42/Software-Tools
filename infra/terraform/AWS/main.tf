module "my-vpc" {
  source         = "./vpc"
  prefix         = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
  env            = var.env
}

module "my-ec2" {
  source          = "./ec2"
  prefix          = var.prefix
  env             = var.env
  vpc_id          = module.my-vpc.vpc_id
  public_subnets  = module.my-vpc.public_subnet_ids
  private_subnets = module.my-vpc.private_subnet_ids
  allowed_ip      = var.allowed_ip
}

# module "my-eks" {
#   source              = "./eks"
#   prefix              = var.prefix
#   env                 = var.env
#   eks_version         = var.eks_version
#   vpc_id              = module.my-vpc.vpc_id
#   eks_cluster_name    = var.eks_cluster_name
#   eks_cluster_version = var.eks_cluster_version
#   private_subnet_ids  = module.my-vpc.private_subnet_ids
#   public_subnet_ids   = module.my-vpc.public_subnet_ids
#   retention_days      = var.retention_days
#   node_desired_size   = var.node_desired_size
#   node_max_size       = var.node_max_size
#   node_min_size       = var.node_min_size
# }

# module "my-users" {
#   source               = "./eks/users"
#   prefix               = var.prefix
#   env                  = var.env
#   eks_cluster_name     = var.eks_cluster_name
#   eks_cluster_fullname = module.my-eks.eks_cluster_fullname
#   eks_version          = var.eks_version
# }

# module "my-hpa" {
#   source = "./eks/hpa"
#   eks_cluster_fullname    = module.my-eks.eks_cluster_fullname
# }

# module "my-autoscaler" {
#   source = "./eks/cluster_autoscaler"
#   region                 = local.region
#   eks_cluster_name        = var.eks_cluster_name
#   eks_cluster_fullname    = module.my-eks.eks_cluster_fullname
# }
