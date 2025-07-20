# AWS WordPress High Availability

## Overview

This project deploys a **highly available WordPress** farm on AWS using Terraform. It includes:

- **Custom VPC** with public and private subnets across two Availability Zones.
- **Application Load Balancer (ALB)** distributing traffic to web servers.
- **Auto Scaling Group** of EC2 instances running Apache & WordPress.
- **RDS MySQL Multi-AZ** backend for durable and resilient data storage.
- **Security Groups** locking down access between tiers.
- **Route 53** DNS configuration for custom subdomain (e.g., `day1.example.com`).

## Architecture

The following diagram illustrates the components and traffic flow:

![Architecture Diagram](https://github.com/tharusha-kudagala/DevOps-Medium/blob/main/aws-wordpress-high-availability/architecture%20diagram.png?raw=true)

## Repository Structure

```

aws-wordpress-high-availability/
├── main.tf            # Root Terraform configuration calling modules
├── variables.tf       # Input variable definitions
├── outputs.tf         # Exported outputs (ALB DNS, RDS endpoint)
├── terraform.tfvars   # Values for variables (sensitive values not checked in)
└── modules/
├── network/       # VPC, subnets, IGW, route tables
├── database/      # RDS MySQL Multi-AZ, subnet group, SG
└── web/           # SG, ALB, target group, launch template, ASG

````

## Prerequisites

- Terraform **>= 1.5**
- AWS CLI configured with credentials and default region
- SSH key pair for EC2 instances
- (Optional) Route 53 Hosted Zone for DNS

## Getting Started

1. **Clone** the repo:
   ```bash
   git clone https://github.com/tharusha-kudagala/DevOps-Medium.git
   cd aws-wordpress-high-availability
```

2. **Configure** `terraform.tfvars` with:

   aws_region       = "us-east-1"
   azs              = ["us-east-1a", "us-east-1b"]
   ami_id           = "ami-0abcdef1234567890"  # Ubuntu AMI
   db_password      = "YourSecureDBPassword"
   route53_zone_id  = "ZXXXXXXXXXXXXX"
   record_name      = "day1"  # Subdomain

3. **Deploy** infrastructure:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Access** your WordPress site:

   * Via **ALB DNS** or your custom domain: `http://day1.example.com`

## Variables

| Name              | Description                     | Default                       |
| ----------------- | ------------------------------- | ----------------------------- |
| `aws_region`      | AWS region                      | `us-east-1`                   |
| `azs`             | List of Availability Zones      | `["us-east-1a","us-east-1b"]` |
| `ami_id`          | Ubuntu AMI ID for web instances | *none* (required)             |
| `db_password`     | RDS Master user password        | *none* (required)             |
| `route53_zone_id` | Hosted Zone ID for Route 53     | *none* (required)             |
| `record_name`     | Subdomain name (e.g., `day1`)   | `day1`                        |

## Outputs

| Name           | Description                                      |
| -------------- | ------------------------------------------------ |
| `alb_dns_name` | Public DNS name of the Application Load Balancer |
| `db_endpoint`  | Endpoint address of the RDS instance             |

## Security

* **Web SG** allows HTTP (80) & SSH (22) from the Internet.
* **DB SG** only allows MySQL (3306) from within the VPC.

## Clean Up

```bash
terraform destroy
```

## License

This project is licensed under the MIT License.
