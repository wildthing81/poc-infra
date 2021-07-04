resource "aws_alb" "app" {
  name                       = "${var.stage}-${var.app_name}-loadbalancer"
  subnets                    = var.alb_subnets
  security_groups            = [aws_security_group.lb.id]
  idle_timeout               = 1800
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "main" {
  name        = "${var.stage}-${var.app_name}-target-group"
  port        = var.service1_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "90"
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.app.id
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-southeast-2:154024441008:certificate/039ea70e-bb31-48b6-89a5-c21b24c537fd"


  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}


resource "aws_route53_zone" "primary" {
  name = "credible-platform.com"
}

resource "aws_route53_record" "alias_route53_record" {
  # Replace with your zone ID
  zone_id = aws_route53_zone.primary.zone_id
  # Replace with your name/domain/subdomain
  name = "api-${var.stage}"
  type = "A"

  alias {
    name                   = aws_alb.app.dns_name
    zone_id                = aws_alb.app.zone_id
    evaluate_target_health = true
  }
}
