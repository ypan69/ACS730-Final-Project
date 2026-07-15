terraform {
  backend "s3" {
    bucket = "prod-project-yiming"         // Bucket where to SAVE Terraform State
    key    = "prod-alb/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                        // Region where bucket is created
  }
}