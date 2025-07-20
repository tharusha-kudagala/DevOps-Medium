variable "vpc_id" {
  description = "ID of the VPC where RDS will live"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS Multi‑AZ"
  type        = list(string)
}

variable "db_name" {
  description = "Initial database name for WordPress"
  type        = string
}

variable "db_user" {
  description = "Master username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}
