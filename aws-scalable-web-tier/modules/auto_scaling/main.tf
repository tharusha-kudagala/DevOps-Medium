// Launch template for EC2 instances in the Auto Scaling group
# Launch template configuration for EC2 instances
resource "aws_launch_template" "web" {
  name_prefix   = "web-lt-"
  image_id      = var.ami_id
  instance_type = "t2.nano"

  user_data = base64encode(<<EOF
#!/bin/bash
#!/bin/bash
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
EOF
  )

  network_interfaces {
    security_groups = [var.sg_id]
  }
}

// Auto Scaling group for web servers
# Auto Scaling group configuration for managing web server instances
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = [var.tg_arn]
}
