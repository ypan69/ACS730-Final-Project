# Local variables
locals {
  default_tags    = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix          = module.globalvars.prefix
  name_prefix     = "${local.prefix}-${title(var.env)}"
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../globalvars"
}

# Create ALB
resource "aws_lb" "web_alb" {
  name                = "${local.name_prefix}-ALB"
  load_balancer_type  = "application"
  internal            = false
  security_groups     = [var.alb_sg_id]
  subnets             = var.public_subnet_ids

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-ALB"
  })
}

#Create target Group
resource "aws_lb_target_group" "web_tg" {
  name      = "${local.name_prefix}-TG"
  port      = 80
  protocol  = "HTTP"
  vpc_id    = var.vpc_id

  health_check {
    enabled = true
    path    = "/"
    port    = "80"
    protocol = "HTTP"
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-TG"
  })
}

# Add listner
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.web_tg.arn
  }
}