# Variable to signal the current environment
variable "env" {
  type        = string
  description = "Deployment environment"
}

# VPC ID
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC to host static web site"
}

# Private subnet IDs
variable "private_subnet_ids" {
  type = list(string)
  description = "Private subnet IDs"
}

# Public subnet IDs
variable "public_subnet_ids" {
  type = list(string)
  description = "Public subnet IDs"
}