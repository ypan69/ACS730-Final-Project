# Provision public subnets in custom VPC
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC to host static web site"
}

# Variable to signal the current environment 
variable "env" {
  type        = string
  description = "Deployment Environment"
}

# VPC availability zones
variable "availability_zones" {
  default = ["us-east-1b", "us-east-1c", "us-east-1d"]
  type = list(string)
  description = "Availability Zone"
}