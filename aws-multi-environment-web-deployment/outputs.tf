output "jumpbox_ip" {
  value = module.ec2.jumpbox_ip
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "staging_private_ip" {
  value = module.ec2.staging_instance_private_ip
}

output "production_private_ip" {
  value = module.ec2.production_instance_private_ip
}

output "api_endpoint" {
  value = module.apigateway.api_endpoint
}
