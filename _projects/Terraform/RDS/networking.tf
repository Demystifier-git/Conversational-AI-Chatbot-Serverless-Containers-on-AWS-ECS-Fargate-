# DB subnet group - requires private_subnet_ids to be provided
resource "aws_db_subnet_group" "db_subnets" {
  count       = length(var.private_subnet_ids) > 0 ? 1 : 0
  name        = "${var.db_identifier}-subnet-group"
  subnet_ids  = var.private_subnet_ids
  description = "DB subnet group for ${var.db_identifier}"
  tags = {
    Name = "${var.db_identifier}-db-subnet-group"
  }
}

# Security group to allow MySQL access (3306). In production, prefer security group references.
resource "aws_security_group" "db_sg" {
  name        = "${var.db_identifier}-sg"
  description = "Security group for ${var.db_identifier} allowing inbound MySQL"
  vpc_id      = var.vpc_id

  ingress {
    description      = "MySQL inbound"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.allowed_cidr]

    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier}-sg"
  }
}
