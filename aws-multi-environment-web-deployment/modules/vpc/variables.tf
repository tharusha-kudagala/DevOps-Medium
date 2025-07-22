variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
  description = "List of public subnet IDs in different AZs"
}


variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "your_ip_cidr" {
  type        = string
  description = "Your IP CIDR for SSH access to the Jumpbox (e.g., 1.2.3.4/32)"
}
