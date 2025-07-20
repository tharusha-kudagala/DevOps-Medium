variable "aws_region" {
  default = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID"
  default     = "ami-0150ccaf51ab55a51"
}

variable "route53_zone_id" {
  description = "The hosted zone ID for nefraverse.com"
  type        = string
  default = "<YOUR_HOSTED_ZONE_ID>"
}