variable "prefix" {
  type    = string
  default = "software-tools"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "eks_version" {
  type    = string
  default = "1.29"
}

variable "eks_cluster_name" {
  type    = string
  default = "my-cluster"
}

variable "eks_cluster_version" {
  type    = string
  default = "1.29"
}

variable "retention_days" {
  type    = number
  default = 1
}

variable "node_desired_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 1
}

variable "node_min_size" {
  type    = number
  default = 0
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "allowed_ip" {
  type = string
}