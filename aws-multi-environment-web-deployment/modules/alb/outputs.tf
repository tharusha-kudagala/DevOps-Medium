output "alb_dns_name" {
  value = aws_lb.multi_env_alb.dns_name
}

output "alb_listener_arn" {
  value = aws_lb_listener.http_listener.arn
}

output "alb_arn" {
  value = aws_lb.multi_env_alb.arn
}
