# Deployment environment
variable "env" {
  type        = string
  description = "Deployment environment"
}

# Launch Template ID
variable "launch_template_id" {
  type        = string
  description = "Launch template ID for ASG"
}

# Private subnet IDs
variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for ASG"
}

# Minimum number of instances
variable "min_size" {
  type        = number
  default     = 1
  description = "Minimum number of instances"
}

# Maximum number of instances
variable "max_size" {
  type        = number
  default     = 4
  description = "Maximum number of instances"
}

# Desired number of instances
variable "desired_capacity" {
  type        = number
  description = "Desired number of instances"
}

# Target group Arn
variable "target_group_arns" {
  type = list(string)
  description = "Target group ARN for ALB attachment"
}