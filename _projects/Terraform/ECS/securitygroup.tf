###################################
# ECS Security Group
###################################
resource "aws_security_group" "my_sg" {
  name        = "chatbot-sg"
  description = "Allow ALB ECS and ECS Secrets Manager"
  vpc_id      = "vpc-0d5e70a92a6125cb1"

  # Allow inbound HTTP from ALB SG
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["sg-0894f59cf45a863b1"] # ALB SG
  }

  # Allow outbound HTTPS to Secrets Manager endpoint SG
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["sg-0be552d8f08ee755f"] # vpc end point sg
  }

  # Outbound HTTPS (to internet, via NAT GW)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}