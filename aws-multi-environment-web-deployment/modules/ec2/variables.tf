variable "ami_id" {}
variable "instance_type" {}
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "key_name" {}
variable "jumpbox_sg_id" {
  description = "Security group ID for jumpbox"
  type        = string
}

variable "private_ec2_sg_id" {
  description = "Security group ID for private EC2s"
  type        = string
}
