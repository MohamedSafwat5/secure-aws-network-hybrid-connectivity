# Security Group for Application Servers

resource "aws_security_group" "app" {
  name        = "app-security-group"
  description = "Allow HTTP traffic from the Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-security-group"
    Tier = "Application"
  }
}

# Security Group for Application Load Balancer

resource "aws_security_group" "alb" {
  name        = "alb-security-group"
  description = "Allow HTTP traffic from the internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
    Tier = "Public"
  }
}

# Security Group for Database

resource "aws_security_group" "database" {
  name        = "database-security-group"
  description = "Allow PostgreSQL traffic from Application Servers only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow PostgreSQL from App Security Group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  tags = {
    Name = "database-security-group"
    Tier = "Database"
  }
}