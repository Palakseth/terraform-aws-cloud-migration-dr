terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # backend "s3" {
  # bucket = "myapp-backup-8ddc9530"
  # key    = "terraform/state.tfstate"
  # region = "us-east-1"
  #}
}

provider "aws" {
  region = var.aws_region
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnet
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "app_sg" {
  name   = "test-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public.id

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
#!/bin/bash

# Install Apache
yum install -y httpd aws-cli
systemctl start httpd
systemctl enable httpd

# Create sample file
echo "Backup test file from EC2 🚀" > /tmp/backup.txt

# Upload to S3
aws s3 cp /tmp/backup.txt s3://${aws_s3_bucket.backup.bucket}/

# Create website page
echo "<h1>Backup Uploaded to S3 🚀</h1>" > /var/www/html/index.html

EOF
  tags = {
    Name = "final-test-ec2"
  }
}

output "public_ip" {
  value = aws_instance.app.public_ip
}
