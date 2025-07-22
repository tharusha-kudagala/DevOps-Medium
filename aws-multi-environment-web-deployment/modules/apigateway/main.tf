resource "aws_apigatewayv2_api" "http_api" {
  name          = "multi-env-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "multi-env-vpc-link"
  subnet_ids         = var.private_subnets
  security_group_ids = var.security_group_ids
}

resource "aws_apigatewayv2_integration" "staging_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.vpc_link.id
  integration_uri        = var.listener_arn
}

resource "aws_apigatewayv2_integration" "prod_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.vpc_link.id
  integration_uri        = var.listener_arn
}

resource "aws_apigatewayv2_route" "staging_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /staging"
  target    = "integrations/${aws_apigatewayv2_integration.staging_integration.id}"
}

resource "aws_apigatewayv2_route" "prod_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /prod"
  target    = "integrations/${aws_apigatewayv2_integration.prod_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}