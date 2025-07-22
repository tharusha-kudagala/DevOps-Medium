provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.0.0/24", "10.0.3.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
  your_ip_cidr    = var.your_ip_cidr
}

module "ec2" {
  source          = "./modules/ec2"
  ami_id          = "ami-020cba7c55df1f615"
  instance_type   = "t2.micro"
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  key_name        = "multi-env-key"

  jumpbox_sg_id     = module.vpc.jumpbox_sg_id
  private_ec2_sg_id = module.vpc.private_ec2_sg_id
}



module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  alb_sg_id           = aws_security_group.alb_sg.id
  staging_instance_id = module.ec2.staging_instance_id
  prod_instance_id    = module.ec2.prod_instance_id
}


module "apigateway" {
  source             = "./modules/apigateway"
  listener_arn       = module.alb.alb_listener_arn
  private_subnets    = module.vpc.private_subnets
  security_group_ids = [aws_security_group.alb_sg.id]
}



resource "aws_security_group" "apigw_sg" {
  name        = "apigw-sg"
  description = "Dummy security group for API Gateway VPC Link"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

