// AMI ID for EC2 instances
variable "ami_id" {
  type = string
}

// List of subnet IDs for the Auto Scaling group
variable "subnet_ids" {
  type = list(string)
}

// Security group ID for EC2 instances
variable "sg_id" {
  type = string
}

// Target group ARN for load balancer
variable "tg_arn" {
  type = string
}
