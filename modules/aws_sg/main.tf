# Local variables
locals {
  default_tags    = merge(module.globalvars.default_tags, { "env" = var.env })
  name_prefix     = "${module.globalvars.prefix}-${title(var.env)}"
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../globalvars"
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${local.name_prefix}-ALB-SG"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.default_tags,{
    Name = "${local.name_prefix}-ALB-SG"
  })
}

# Security Group for Bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "${local.name_prefix}-Bastion-SG"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from private IP of CLoud9 machine"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-Bastion-SG"
  })
}

# Security Group for VMs
resource "aws_security_group" "web_sg" {
  name        = "${local.name_prefix}-Web-SG"
  description = "Web server security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]

  }

 ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-Web-SG"
  })
}