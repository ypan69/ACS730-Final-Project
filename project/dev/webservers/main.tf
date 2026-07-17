# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Use remote state to retrieve the data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "${var.env}-${lower(local.prefix)}-${lower(local.owner)}"       // Bucket from where to GET Terraform State
    key    = "${var.env}-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}

# Define tags locally
locals {
  prefix       = module.globalvars.prefix  
  owner        = module.globalvars.default_tags["Owner"]
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}

# Module to deploy basic webservers
module "webservers" {
  source = "../../../modules/aws_webservers"
  env                   = var.env
  vpc_id                = data.terraform_remote_state.network.outputs.vpc_id
  vpc_cidr              = data.terraform_remote_state.network.outputs.vpc_cidr
  public_subnet_ids     = data.terraform_remote_state.network.outputs.public_subnet_ids
  private_subnet_ids    = data.terraform_remote_state.network.outputs.private_subnet_ids
}