variable "aws_region" {
  default = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "Ubuntu 24.04 AMI ID"
  default     = "ami-020cba7c55df1f615"
}

variable "route53_zone_id" {
  description = "The hosted zone ID for nefraverse.com"
  type        = string
  default = "<YOUR_HOSTED_ZONE_ID>"
}