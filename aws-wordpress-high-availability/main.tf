provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"
  azs    = var.azs
}

module "database" {
  source             = "./modules/database"
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}

module "web" {
  source            = "./modules/web"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  ami_id            = var.ami_id

  db_endpoint = module.database.db_endpoint
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}

resource "aws_route53_record" "day2" {
  zone_id = var.route53_zone_id
  name    = "<YOUR_DOMAIN OR SUB_DOMAIN>"
  type    = "A"

  alias {
    name                   = module.web.alb_dns_name
    zone_id                = module.web.alb_zone_id
    evaluate_target_health = true
  }
}
