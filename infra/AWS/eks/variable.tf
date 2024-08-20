variable "prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "eks_version" {
    type = string
}

variable "vpc_id" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "retention_days" {
  type = number
}

variable "node_desired_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "node_min_size" {
  type = number
}