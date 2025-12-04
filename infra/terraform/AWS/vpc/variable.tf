variable "prefix" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "env" {
  type = string
}

variable "public_availability_zones" {
  type = list(string)
  default = ["us-east-1e", "us-east-1f"]
}