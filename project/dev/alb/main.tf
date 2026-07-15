# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Retrieve network state
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-acs730-${lower(local.prefix)}-${lower(local.owner)}"
    key    = "${var.env}-network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Retrieve webserver state
data "terraform_remote_state" "webservers" {
  backend = "s3"
  config = {
    bucket = "${var.env}-acs730-${lower(local.prefix)}-${lower(local.owner)}"
    key    = "${var.env}-webservers/terraform.tfstate"
    region = "us-east-1"
  }
}

# Define tags locally
locals {
  prefix = module.globalvars.prefix
  owner  = module.globalvars.default_tags["Owner"]
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}

# Module to deploy alb
module "alb" {
  source = "../../../modules/aws_alb"

  env               = var.env
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
  alb_sg_id         = data.terraform_remote_state.webservers.outputs.alb_sg_id
}