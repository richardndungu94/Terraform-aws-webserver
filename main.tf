terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create a simple security group for SSH and HTTP
resource "aws_security_group" "web" {
  name        = "demo-web-ssh"
  description = "Allow SSH and HTTP Access"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-ssh-security-group"
  }
}

# Create a key pair from the local public key
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-demo-key"
  public_key = file(var.public_key_path)
}

# Launch EC2 instance with web server
resource "aws_instance" "demo" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.deployer.key_name

  # User data script that installs and configures Apache
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create simple HTML Page
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Terraform Demo</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          color: white;
                      }
                      .container {
                          text-align: center;
                          padding: 40px;
                          background: rgba(255,255,255,0.1);
                          border-radius: 10px;
                          box-shadow: 0 8px 32px rgba(0,0,0,0.3);
                      }
                      h1 { margin: 0 0 20px 0; }
                      p { font-size: 18px; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1> Terraform Test Project</h1>
                      <p>The web server is running successfully</p>
                      <p>Deployed with IaC - This is a Terraform demo</p>
                  </div>
              </body>
              </html>
HTML
              EOF

  tags = {
    Name = "terraform-web-server"
  }
}

