# Instance type
output "instance_type" {
  value = {
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }
}

# Default tags
output "default_tags" {
  value = {
    Owner  = "Yiming"
    App    = "Web"
  }
}

# Prefix to identify resources
output "prefix" {
  value     = "Assignment"
}


