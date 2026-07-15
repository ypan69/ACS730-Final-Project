# Deployment environment
variable "env" {
  default     = "staging"
  type        = string
  description = "Deployment environment"
}

# Desired number of instances
variable "desired_capacity" {
  default     = 3
  type        = number
  description = "Desired ASG instances"
}