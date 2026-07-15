# Variable to signal the current environment 
variable "env" {
  type        = string
  description = "Deployment Environment"
}

# VPC ID
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

# Public subnet IDs
variable "public_subnet_ids" {
  type = list(string)
  description = "Public subnet IDs"
}

# ALB security group ID
variable "alb_sg_id" {
  type        = string
  description = "ALB security group ID"
}