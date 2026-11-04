# IAM Role for EC2 instances to access AWS Systems Manager

resource "aws_iam_role" "ec2_ssm" {
  name = "secure-network-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name    = "ec2-ssm-role"
    Project = "secure-aws-network-hybrid-connectivity"
  }
}

# Attach AWS managed policy for Systems Manager

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile attached to EC2 instances

resource "aws_iam_instance_profile" "ec2" {
  name = "secure-network-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm.name
}