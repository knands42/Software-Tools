module "my-vpc" {
  source         = "./vpc"
  prefix         = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
  env             = var.env
}

# module "my-rds-postgres" {
#   source            = "./modules/rds"
#   prefix            = var.prefix
#   database_name     = var.database_name
#   database_username = var.database_username
# }

# module "my-eks" {
#   source              = "./modules/eks"
#   prefix              = var.prefix
#   vpc_id              = module.my-vpc.vpc_id
#   eks_cluster_name    = var.eks_cluster_name
#   eks_cluster_version = var.eks_cluster_version
#   retention_days      = var.retention_days
#   node_desired_size   = var.node_desired_size
#   node_max_size       = var.node_max_size
#   node_min_size       = var.node_min_size
# }