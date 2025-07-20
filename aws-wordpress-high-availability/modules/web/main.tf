resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP & SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.web_sg.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = var.ami_id
  instance_type = "t3.micro"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # 1) Install Apache & PHP
    sudo apt-get update -y
    sudo apt-get install -y apache2 php php-mysql libapache2-mod-php wget unzip

    # 2) Enable & start Apache
    sudo systemctl enable apache2
    sudo systemctl start apache2

    # 3) Deploy WordPress
    cd /var/www/html
    sudo wget -q https://wordpress.org/latest.tar.gz
    sudo tar -xzf latest.tar.gz
    sudo cp -r wordpress/* .
    sudo rm -rf wordpress latest.tar.gz index.html
    sudo chown -R www-data:www-data /var/www/html

    # 4) Configure wp-config.php
    sudo cp wp-config-sample.php wp-config.php
    sudo sed -i "s/database_name_here/wordpress/" wp-config.php
    sudo sed -i "s/username_here/admin/"        wp-config.php
    sudo sed -i "s/password_here/${var.db_password}/" wp-config.php
    sudo sed -i "s/localhost/${var.db_endpoint}/"     wp-config.php

    # 5) Give Apache a moment, then restart
    sleep 3
    sudo systemctl restart apache2
EOF
  )

  network_interfaces {
    security_groups = [aws_security_group.web_sg.id]
  }
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity        = 2
  min_size                = 2
  max_size                = 4
  vpc_zone_identifier     = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns         = [aws_lb_target_group.tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "ALB hosted zone ID (for Route53 alias)"
  value       = aws_lb.alb.zone_id
}
