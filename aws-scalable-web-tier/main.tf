# Main Terraform configuration for AWS scalable web tier
# This file provisions VPC, security groups, ALB, Auto Scaling, and Route53 DNS record

# Configure AWS provider with region
provider "aws" {
  region = var.aws_region
}

# VPC module: provisions the Virtual Private Cloud and subnets
module "vpc" {
  source = "./modules/vpc"
  azs = var.azs
}

# Security Group module: provisions security groups for the infrastructure
module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

# ALB module: provisions Application Load Balancer and related resources
module "alb" {
  source = "./modules/alb"
  subnet_ids = module.vpc.public_subnet_ids
  sg_id      = module.security_group.web_sg_id
  vpc_id     = module.vpc.vpc_id
}

# Auto Scaling module: provisions EC2 Auto Scaling Group for web servers
module "auto_scaling" {
  source    = "./modules/auto_scaling"
  ami_id    = var.ami_id
  subnet_ids = module.vpc.public_subnet_ids
  sg_id      = module.security_group.web_sg_id
  tg_arn    = module.alb.target_group_arn
}

# Route53 DNS record: creates an alias record pointing to the ALB
resource "aws_route53_record" "day1" {
  zone_id = var.route53_zone_id
  name    = "<YOUR_DOMAIN OR SUB_DOMAIN>"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}