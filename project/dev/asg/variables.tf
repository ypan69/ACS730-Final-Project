# Deployment environment
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment environment"
}

# Desired number of instances
variable "desired_capacity" {
  default     = 2
  type        = number
  description = "Desired ASG instances"
}