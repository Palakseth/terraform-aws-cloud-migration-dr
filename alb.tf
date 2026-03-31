# ================================
# Load Balancer
# ================================
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  subnets = [
  aws_subnet.public.id,
  aws_subnet.public_b.id
]

  security_groups = [aws_security_group.app_sg.id]
}

# ================================
# Target Group
# ================================
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/"
  }
}

# ================================
# Listener
# ================================
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# ================================
# Launch Template
# ================================
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd
echo "Hello from Auto Scaling 🚀" > /var/www/html/index.html
EOF
  )
}

# ================================
# Auto Scaling Group
# ================================
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = [aws_subnet.public.id,
aws_subnet.public_b.id
]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]
}
