#
# Fetch the VPC CIDR so we can lock down access to your web tier.
#
data "aws_vpc" "this" {
  id = var.vpc_id
}

#
# Security Group: Allow MySQL (3306) inbound from anywhere in the VPC.
#
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow MySQL from web tier VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ data.aws_vpc.this.cidr_block ]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#
# Subnet group for Multi‑AZ RDS
#
resource "aws_db_subnet_group" "db_subnets" {
  name       = "db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "db-subnet-group"
  }
}

#
# The RDS instance itself
#
resource "aws_db_instance" "db" {
  identifier             = "day3-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20

  # ← Correct attribute name for the database
  db_name                = var.db_name

  username               = var.db_user
  password               = var.db_password

  # point at our subnet group and SG
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  multi_az               = true
  publicly_accessible    = false
  skip_final_snapshot    = true
}

#
# Expose the endpoint so web can consume it
#
output "db_endpoint" {
  description = "RDS endpoint (DNS) to connect WordPress"
  value       = aws_db_instance.db.address
}
