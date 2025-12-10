terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49"
    }
  }
  # backend "s3" {
  # bucket = "terraform-locks-knands42"
  #    key            = "aws-demo/dev/terraform.tfstate"
  #    region         = "us-east-1"

  #    dynamodb_table = "terraform-locks-knands42"
  #    encrypt        = true
  # }
}

provider "aws" {
  region = local.region
}
