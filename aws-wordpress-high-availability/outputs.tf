output "alb_dns_name" {
  description = "Application Load Balancer DNS"
  value       = module.web.alb_dns_name
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = module.database.db_endpoint
}
