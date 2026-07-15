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

# Retrieve alb state
data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "${var.env}-acs730-${lower(local.prefix)}-${lower(local.owner)}"
    key    = "${var.env}-alb/terraform.tfstate"
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

# Module to deploy asg
module "asg" {
  source = "../../../modules/aws_asg"

  env = var.env
  launch_template_id    = data.terraform_remote_state.webservers.outputs.launch_template_id
  private_subnet_ids    = data.terraform_remote_state.network.outputs.private_subnet_ids
  desired_capacity      = var.desired_capacity
  target_group_arns = [data.terraform_remote_state.alb.outputs.target_group_arn]
}