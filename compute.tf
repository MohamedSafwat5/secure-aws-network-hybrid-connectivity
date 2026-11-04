# Get the latest Amazon Linux 2023 AMI

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Application EC2 Instances in Private Subnets

resource "aws_instance" "app" {
  for_each = {
    app_a = aws_subnet.app_a.id
    app_b = aws_subnet.app_b.id
  }
  depends_on = [
    aws_iam_role_policy_attachment.ec2_ssm
  ]
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = "t3.micro"
  subnet_id                   = each.value
  vpc_security_group_ids      = [aws_security_group.app.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    dnf install -y nginx

    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
      <head>
        <title>Secure AWS Application</title>
      </head>
      <body>
        <h1>Secure AWS Network Architecture</h1>
        <p>Application instance: ${each.key}</p>
        <p>Amazon Linux 2023 + Nginx</p>
      </body>
    </html>
    HTML

    systemctl enable nginx
    systemctl start nginx
  EOF

  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "secure-app-${each.key}"
    Tier = "Application"
  }
}