variable "prefix" {
  type    = string
  default = "software-tools"
}

variable "cluster_name" {
  type    = string
  default = "software-tools-cluster"
}

variable "ecr_repository" {
  type    = string
  default = "software-tools-ecr"
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
  default = 1
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "database_name" {
  type    = string
  default = "software_tools_db"
}

variable "database_username" {
  type    = string
  default = "masteruser"
}

variable "database_port" {
  type    = number
  default = 5432
}