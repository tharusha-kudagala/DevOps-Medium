
# AWS Scalable Web Tier (Day 1 Challenge)

## Overview

This project demonstrates a **highly available and scalable web tier architecture on AWS** using Terraform.

### Architecture Diagram

![AWS Scalable Web Tier](https://github.com/tharusha-kudagala/DevOps-Medium/blob/main/aws-scalable-web-tier/architecture.drawio.png?raw=true)

## Components

- **VPC with Public Subnets** across two Availability Zones
- **Auto Scaling Group** running **NGINX** (Amazon Linux 2023)
- **Application Load Balancer (ALB)** to distribute traffic
- **Elastic IP (Optional)** for manual instance testing
- **Route 53 DNS Record** mapping `day1.nefraverse.com` to the ALB

## Features

- Modular Terraform code
- Zero downtime scalability
- Clean separation of components (VPC, ALB, ASG, SG)
- Secure by design (no public IPs for EC2 instances by default)

## Setup Instructions

### Prerequisites

- Terraform >= 1.5
- AWS CLI configured with appropriate credentials
- Domain `nefraverse.com` managed in Route 53 (for DNS)

### How to Deploy

```bash
cd main
terraform init
terraform plan
terraform apply
```

### Variables

| Variable | Description | Default |
|-----------|-------------|---------|
| aws_region | AWS Region | us-east-1 |
| azs | Availability Zones | ["us-east-1a", "us-east-1b"] |
| ami_id | Amazon Linux 2023 AMI | ami-0c02fb55956c7d316 |
| route53_zone_id | Route 53 Zone ID | (Set this manually) |

## Outputs

- **ALB DNS Name**
- **Route53 Record:** `xxx.yyy.com`

## Security

- **ALB**: Internet-facing, listens on port 80
- **Auto Scaling Group EC2 Instances**: Private IPs only (access via ALB)
- **Security Groups**: ALB can reach EC2 on port 80, SSH is optional for debugging

## License

This project is part of the **Nefraverse Cloud Architectures** series and is licensed under the MIT License.
