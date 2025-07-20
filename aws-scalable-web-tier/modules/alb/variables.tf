// List of subnet IDs for the ALB
// Variables for ALB module
// This file defines input variables for the ALB resources
variable "subnet_ids" {
  type = list(string)
}

// Security group ID for the ALB
// Security group ID for the ALB
variable "sg_id" {
  type = string
}

// VPC ID for the ALB
// VPC ID for the ALB
variable "vpc_id" {
  type = string
}
