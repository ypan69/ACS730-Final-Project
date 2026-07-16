# ACS730 Final Project - Two-Tier Web Application Automation with Terraform
Yiming

## Project Overview
This project deploys a highly available two-tier web application infrastructure on AWS using Terraform.
The solution uses a modular Terraform design with separate environments:

- Development (`dev`)
- Staging (`staging`)
- Production (`prod`)

Each environment contains independent Terraform configurations while sharing reusable Terraform modules.
The infrastructure includes:

- VPC networking
- Public and private subnets
- Security Groups
- EC2 Launch Template
- Bastion Host
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- CloudWatch monitoring and dynamic scaling policies
- S3-hosted website images

---
## Naming Convention
All AWS resources follow an environment-based naming convention.
Example:
```text
Yiming-Dev-<Resource>
Yiming-Staging-<Resource>
Yiming-Prod-<Resource>
```
---
## Project Structure
```text
ACS730-Final-Project/
├── project/
│   ├── dev/
│   │   ├── network/
│   │   ├── webservers/
│   │   ├── alb/
│   │   └── asg/
│   │
│   ├── staging/
│   │   ├── network/
│   │   ├── webservers/
│   │   ├── alb/
│   │   └── asg/
│   │
│   ├── prod/
│   │   ├── network/
│   │   ├── webservers/
│   │   ├── alb/
│   │   └── asg/
│   │
├── modules/
│   ├── aws_network/
│   ├── aws_webservers/
│   ├── aws_alb/
│   ├── aws_asg/
│   ├── aws_sg/
│   └── globalvars/
│   
├── .github/
     └── workflows/
           └── tfsec.yml
```
---
# Prerequisites
Before deployment, install and configure the following tools:
## Required Tool
- Terraform
Verify installation:
```text
terraform version
```
---
## S3 Requirements
### Terraform Remote State
Each environment requires an S3 bucket to store Terraform remote state.
Example:
```text
dev-project-yiming
staging-project-yiming
prod-project-yiming
```
Terraform state files are stored separately for each Terraform component.
Example:
```text
dev-network/terraform.tfstate
dev-webservers/terraform.tfstate
dev-alb/terraform.tfstate
dev-asg/terraform.tfstate
```
The same structure is used for staging and production environments.
---
## Website Images
The web servers load website images from a private S3 bucket.
Images must be uploaded manually before deployment.
Required files:
```text
image/
├── banner.jpg
└── logo.png
```
---
# Terraform Deployment
Terraform deployment should be performed in the following order.
The same deployment process applies to:
```text
dev/
staging/
prod/
```
---
## 1. Deploy Networking
Example for Development:
```text
cd ../network
terraform init
terraform apply
```
This creates:
```text
VPC
Public Subnets
Private Subnets
Internet Gateway
NAT Gateway
Route Tables
```
---
## 2. Deploy Web Servers and Bastion Host
```text
cd ../webservers
terraform init
terraform apply
```
This creates:
```text
EC2 Launch Template
IAM Instance Profile
Security Groups
Bastion Host
```
---
## 3. Deploy Application Load Balancer
```text
cd ../alb
terraform init
terraform apply
```
This creates:
```text
Application Load Balancer
Target Group
Listeners
```
---
## 4. Deploy Auto Scaling Group
```text
cd ../asg
terraform init
terraform apply
```
This creates:
```text
Auto Scaling Group
Launch Template Association
CloudWatch Alarms
Scaling Policies
```
---
# Terraform Remote State
The project uses Terraform remote state to connect infrastructure components.
Example:
```text
Network
   ↓
Webservers
   ├──> ALB
   └──> ASG
```
Remote state allows different Terraform configurations to share resource outputs:
```text
VPC ID
Subnet IDs
Security Group IDs
Launch Template ID
Target Group ARN
```
---
# Auto Scaling and Monitoring
The Auto Scaling Group uses CloudWatch alarms for dynamic scaling.
## Scale Out
When CPU utilization exceeds the configured threshold:
```text
CloudWatch Alarm
        ↓
Scale-Out Policy
        ↓
Add EC2 Instance
```
---
## Scale In
When CPU utilization decreases:
```text
CloudWatch Alarm
        ↓
Scale-In Policy
        ↓
Remove EC2 Instance
```
---
# Security Scanning
GitHub Actions automatically performs Terraform security scanning.
Workflow location:
```text
.github/workflows/tfsec.yml
```
Security scans are triggered by:
```text
Push events
Pull requests
```
The workflow uses:
```text
tfsec
```
to detect security issues in Terraform configurations.
---
# Cleanup
Destroy resources in reverse deployment order.
## Remove Auto Scaling Group
```text
cd ../asg
terraform destroy
```
---
## Remove Load Balancer
```text
cd ../alb
terraform destroy
```
---
## Remove Web Servers and Bastion Host
```text
cd ../webservers
terraform destroy
```
---
## Remove Network
```text
cd ../network
terraform destroy
```
Repeat the same cleanup process for:
```text
staging/
prod/
```
