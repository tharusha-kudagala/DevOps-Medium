variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ami_id" {
  description = "Web server AMI"
  type        = string
}

variable "db_endpoint" {
  description = "RDS endpoint"
  type        = string
}

variable "db_name" {
  description = "WordPress DB name"
  type        = string
}

variable "db_user" {
  description = "WordPress DB user"
  type        = string
}

variable "db_password" {
  description = "WordPress DB password"
  type        = string
}