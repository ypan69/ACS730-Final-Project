# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Retrieve role
data "aws_iam_instance_profile" "ec2_profile" {
  name = "LabInstanceProfile"
}

# Local variables
locals {
  default_tags    = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix          = module.globalvars.prefix
  name_prefix     = "${local.prefix}-${title(var.env)}"
  owner        = module.globalvars.default_tags["Owner"]
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../globalvars"
}

#Retrieve security groups
module "sg"{
  source = "../aws_sg"

  env       = var.env
  vpc_id    = var.vpc_id
  vpc_cidr = var.vpc_cidr
}

# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = "${var.env}"
  public_key = file("${path.module}/${var.env}.pub")
}

# Reference provisioned by Networking
resource "aws_launch_template" "my_amazon" {
  image_id                      = data.aws_ami.latest_amazon_linux.id
  instance_type                 = lookup(module.globalvars.instance_type, var.env)
  key_name                      = aws_key_pair.web_key.key_name
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [module.sg.web_sg_id]
  }
  
  user_data                     = base64encode(templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env         = upper(var.env)
      prefix      = upper(local.prefix)
      bucket_name = "${var.env}-acs730-${lower(local.prefix)}-${lower(local.owner)}"
    }
  ))
  
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
      encrypted = var.env == "prod" ? true : false
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    name = data.aws_iam_instance_profile.ec2_profile.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.default_tags, {
      Name = "${local.name_prefix}-Webserver"
    })
  }
}

# Deploy bastion
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(module.globalvars.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = var.public_subnet_ids[0]
  security_groups             = [module.sg.bastion_sg_id]

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-Bastion"
  })
}