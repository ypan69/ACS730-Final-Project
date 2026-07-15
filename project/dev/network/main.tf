# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Module to deploy basic networking 
module "vpc" {
  source = "../../../modules/aws_network"
  env                   = var.env
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
}
