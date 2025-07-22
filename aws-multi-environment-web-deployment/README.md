
# Multi-Environment Deployment on AWS

## Architecture Overview

This project deploys a **staging** and **production** environment on AWS using:
- API Gateway (Custom domain with Route53)
- Application Load Balancer (ALB) with path-based routing
- Private EC2 instances for staging and production
- Jumpbox in public subnet for SSH access
- VPC Link from API Gateway to ALB

## Architecture Diagram

![AWS Scalable Web Tier](https://github.com/tharusha-kudagala/DevOps-Medium/blob/main/aws-multi-environment-web-deployment/day3.png?raw=true)


## Bash Deployment Script

This script installs Apache2, enables mod_rewrite, and configures `.htaccess` for path rewrites to `/`.

### How to Deploy

```bash
terraform init
terraform plan
terraform apply
./deploy-env.sh
```

## Security Groups

- **Jumpbox SG:** Allows SSH from your IP and HTTP (port 80)
- **Private EC2 SG:** Allows HTTP from ALB and SSH from Jumpbox

## License

MIT
