# Main VPC ID

output "vpc_id" {
  description = "ID of the main project VPC"
  value       = aws_vpc.main.id
}

# Public Subnet IDs

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

# Private Application Subnet IDs

output "app_subnet_ids" {
  description = "IDs of the private application subnets"
  value = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id
  ]
}

# Private Database Subnet IDs

output "db_subnet_ids" {
  description = "IDs of the private database subnets"
  value = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]
}

# Application Load Balancer Security Group ID

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

# Application Security Group ID

output "app_security_group_id" {
  description = "ID of the application security group"
  value       = aws_security_group.app.id
}

# Database Security Group ID

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database.id
}

