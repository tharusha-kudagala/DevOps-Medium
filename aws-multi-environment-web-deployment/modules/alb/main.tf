resource "aws_lb" "multi_env_alb" {
  name               = "multi-env-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.alb_sg_id]

  tags = {
    Name = "multi-env-alb"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.multi_env_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "staging_tg" {
  name        = "staging-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }
}

resource "aws_lb_target_group" "prod_tg" {
  name        = "prod-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }
}

resource "aws_lb_target_group_attachment" "staging_attachment" {
  target_group_arn = aws_lb_target_group.staging_tg.arn
  target_id        = var.staging_instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "prod_attachment" {
  target_group_arn = aws_lb_target_group.prod_tg.arn
  target_id        = var.prod_instance_id
  port             = 80
}

resource "aws_lb_listener_rule" "staging" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.staging_tg.arn
  }

  condition {
    path_pattern {
      values = ["/staging"]
    }
  }
}

resource "aws_lb_listener_rule" "prod" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_tg.arn
  }

  condition {
    path_pattern {
      values = ["/prod"]
    }
  }
}


