variable "prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpn_certs_path" {
  type = string
}
