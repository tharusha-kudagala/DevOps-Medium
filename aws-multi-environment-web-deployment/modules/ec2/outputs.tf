output "staging_instance_private_ip" {
  value = aws_instance.staging.private_ip
}

output "production_instance_private_ip" {
  value = aws_instance.production.private_ip
}

# output "prod_instance_id" {
#   value = aws_instance.prod.id
# }

# output "staging_instance_id" {
#   value = aws_instance.staging.id
# }
