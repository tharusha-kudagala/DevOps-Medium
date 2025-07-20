variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "AMI ID for web servers (Ubuntu 24.04)"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "db_name" {
  description = "WordPress database name"
  type        = string
  default     = "wordpress"
}

variable "db_user" {
  description = "WordPress database user"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "WordPress / RDS admin password"
  type        = string
}

variable "route53_zone_id" {
  description = "The hosted zone ID for nefraverse.com"
  type        = string
  default = "<YOUR_HOSTED_ZONE_ID>"
}