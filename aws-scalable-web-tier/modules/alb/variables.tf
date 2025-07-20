// List of subnet IDs for the ALB
variable "subnet_ids" {
  type = list(string)
}

// Security group ID for the ALB
variable "sg_id" {
  type = string
}

// VPC ID for the ALB
variable "vpc_id" {
  type = string
}
