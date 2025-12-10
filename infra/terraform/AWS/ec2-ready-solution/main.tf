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
  ssh_path        = var.ssh_path
}

module "my-acm" {
  source          = "./acm"
  prefix          = var.prefix
  env             = var.env
  private_subnets = module.my-vpc.private_subnet_ids
  vpc_cidr_block  = var.vpc_cidr_block
  vpn_certs_path  = var.vpn_certs_path
}
