provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  azs = var.azs
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"
  subnet_ids = module.vpc.public_subnet_ids
  sg_id      = module.security_group.web_sg_id
  vpc_id     = module.vpc.vpc_id
}

module "auto_scaling" {
  source    = "./modules/auto_scaling"
  ami_id    = var.ami_id
  subnet_ids = module.vpc.public_subnet_ids
  sg_id      = module.security_group.web_sg_id
  tg_arn    = module.alb.target_group_arn
}

resource "aws_route53_record" "day1" {
  zone_id = var.route53_zone_id
  name    = "day1.nefraverse.com"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}