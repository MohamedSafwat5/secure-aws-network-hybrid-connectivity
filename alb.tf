# Application Load Balancer

resource "aws_lb" "app" {
  name               = "secure-network-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name = "secure-network-alb"
    Tier = "Public"
  }
}

# Target Group for Application Instances

resource "aws_lb_target_group" "app" {
  name        = "secure-app-targets"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "secure-app-target-group"
  }
}

# Register EC2 Instances in the Target Group

resource "aws_lb_target_group_attachment" "app" {
  for_each = aws_instance.app

  target_group_arn = aws_lb_target_group.app.arn
  target_id        = each.value.id
  port             = 80
}

# HTTP Listener

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}