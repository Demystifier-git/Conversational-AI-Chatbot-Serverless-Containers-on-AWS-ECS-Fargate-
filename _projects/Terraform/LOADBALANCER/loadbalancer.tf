provider "aws" {
  region = "us-east-1" # change to your AWS region
}

# 🔹 Data lookup: get VPC by name tag
data "aws_vpc" "my_vpc" {
  id = "vpc-0d5e70a92a6125cb1"
}


# 🔹 Data lookup: get public subnets in this VPC
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my_vpc.id]
  }

  # Assuming your subnets are tagged as public
  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
}

# 🔹 Security Group for ALB (allow HTTP inbound)
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound"
  vpc_id      = data.aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]   # allow HTTPS from anywhere
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🔹 Target Group
resource "aws_lb_target_group" "my_tg" {
  name        = "my-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.my_vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = [
    "subnet-0009d7d8b799d4199", # us-east-1a
    "subnet-0bbe58f3673670282"  # us-east-1b
  ]

  enable_deletion_protection = false
}

# 🔹# 🔹 HTTP Listener that redirects to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# 🔹 HTTPS Listener with ACM certificate
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = "arn:aws:acm:us-east-1:920216467853:certificate/2d576d86-5fc3-4f85-b466-14c1e52f5b26"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}


# 🔹 Output the ALB DNS Name
output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

