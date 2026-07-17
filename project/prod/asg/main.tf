# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Retrieve network state
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-${lower(local.prefix)}-${lower(local.owner)}"       // Bucket from where to GET Terraform State
    key    = "${var.env}-networkterraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1" // Region where bucket created
  }
}

# Retrieve webserver state
data "terraform_remote_state" "webservers" {
  backend = "s3"
  config = {
    bucket = "${var.env}-${lower(local.prefix)}-${lower(local.owner)}"       // Bucket from where to GET Terraform State
    key    = "${var.env}-webserversterraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1" // Region where bucket created
  }
}

# Retrieve alb state
data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "${var.env}-${lower(local.prefix)}-${lower(local.owner)}"       // Bucket from where to GET Terraform State
    key    = "${var.env}-albterraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1" // Region where bucket created
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