variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "alb_sg_id" {}
variable "staging_instance_id" {}
variable "prod_instance_id" {}
