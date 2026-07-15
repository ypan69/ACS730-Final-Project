# ACS730 Final Project - Two-Tier web application automation with Terraform
Yiming

## Project Overview

This project deploys a highly available web application infrastructure on AWS using Terraform.

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
│   ├── modules/
│   │   ├── aws_network/
│   │   ├── aws_webservers/
│   │   ├── aws_alb/
│   │   ├── aws_asg/
│   │   ├── aws_sg/
│   │   └── globalvars/
│   │
│   └── .github/
│       └── workflows/
│           └── tfsec.yml
```
---

# Prerequisites

Before deployment, install and configure:

## Required Tool
- Terraform

Verify installations:
terraform version

S3 Requirements
Terraform Remote State
Each environment requires an S3 bucket to store Terraform state.
Example:

dev-acs730-assignment-yiming
staging-acs730-assignment-yiming
prod-acs730-assignment-yiming

Terraform state files are stored separately:
Example:

dev-network/terraform.tfstate
dev-webservers/terraform.tfstate
dev-alb/terraform.tfstate
dev-asg/terraform.tfstate

The same structure is used for staging and production environments.

Website Images
The web servers load images from S3.
Images must be uploaded manually before deployment.
Required files:

```text
image/
├── banner.jpg
└── logo.png
```

Terraform Deployment
Terraform deployment should be performed in the following order:
1. Deploy Networking
Example for Development:

cd dev/network
terraform init
terraform plan
terraform apply

2. Deploy Web Servers and Bastion Host

cd dev/webservers
terraform init
terraform plan
terraform apply

This creates:
EC2 Launch Template
Security Groups
Bastion Host

3. Deploy Application Load Balancer

cd dev/alb
terraform init
terraform plan
terraform apply

4. Deploy Auto Scaling Group

cd dev/asg
terraform init
terraform plan
terraform apply

The same deployment process applies to:
staging/
prod/


Terraform Remote State
The project uses Terraform remote state to connect infrastructure components.

Examples:
```text
Network
   ↓
Webservers
   ├──> ALB
   └──> ASG
```

Remote state allows different Terraform configurations to share resource outputs such as:
VPC ID
Subnet IDs
Security Group IDs
Launch Template ID
Target Group ARN
Auto Scaling and Monitoring

The Auto Scaling Group uses CloudWatch alarms for dynamic scaling.

Scale Out
When CPU utilization exceeds the configured threshold:
```text
CloudWatch Alarm
        ↓
Scale-Out Policy
        ↓
Add EC2 instance
```

Scale In
When CPU utilization decreases:
```text
CloudWatch Alarm
        ↓
Scale-In Policy
        ↓
Remove EC2 instance
```

Security Scanning
GitHub Actions are configured to automatically perform Terraform security scanning.
Workflow location:
.github/workflows/tfsec.yml

Security scans are triggered by:
Push events
Pull requests
The workflow uses:
tfsec

to detect security issues in Terraform configurations.


Cleanup
Destroy resources in reverse order:
Remove Auto Scaling Group

cd dev/asg
terraform destroy

Remove Load Balancer

cd dev/alb
terraform destroy

Remove Web Servers and Bastion

cd dev/webservers
terraform destroy

Remove Network

cd dev/network
terraform destroy

Repeat the same process for:
staging
prod
