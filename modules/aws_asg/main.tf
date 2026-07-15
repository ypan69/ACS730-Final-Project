# Local variables
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${title(var.env)}"
}

# Retrieve global variables
module "globalvars" {
  source = "../globalvars"
}


# Create Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  name = "${local.name_prefix}-ASG"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.private_subnet_ids


  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-Webserver"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Dynamic scaling out policies 
resource "aws_autoscaling_policy" "scale_out" {
  name = "${local.name_prefix}-Scale-Out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 60
}

# Dynamic scaling in policies
resource "aws_autoscaling_policy" "scale_in" {
  name = "${local.name_prefix}-Scale-In"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 60
}

#High CPU Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name = "${local.name_prefix}-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

#Low CPU Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name = "${local.name_prefix}-CPU-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 5

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}