resource "aws_instance" "jumpbox" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnets[0]
  key_name      = var.key_name

  vpc_security_group_ids = [var.jumpbox_sg_id]

  tags = {
    Name = "Jumpbox"
  }
}

resource "aws_instance" "staging" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnets[0]
  key_name      = var.key_name

  vpc_security_group_ids = [var.private_ec2_sg_id]

  tags = {
    Name = "Staging"
  }
}

resource "aws_instance" "production" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnets[1]
  key_name      = var.key_name

  vpc_security_group_ids = [var.private_ec2_sg_id]

  tags = {
    Name = "Production"
  }
}

resource "aws_eip" "jumpbox_eip" {
  instance = aws_instance.jumpbox.id
  domain   = "vpc"
}

output "staging_instance_id" {
  value = aws_instance.staging.id
}

output "prod_instance_id" {
  value = aws_instance.production.id
}

output "jumpbox_ip" { value = aws_eip.jumpbox_eip.public_ip }
