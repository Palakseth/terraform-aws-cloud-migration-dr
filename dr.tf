# IAM Role for snapshot automation
resource "aws_iam_role" "dlm_role" {
  name = "dlm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "dlm.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "dlm_attach" {
  role       = aws_iam_role.dlm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataLifecycleManagerServiceRole"
}

# EBS Snapshot Lifecycle Policy
resource "aws_dlm_lifecycle_policy" "ebs_backup" {
  description        = "Daily backup"
  execution_role_arn = aws_iam_role.dlm_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    target_tags = {
      Name = "${var.project_name}-ec2"
    }

    schedule {
      name = "daily-backup"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
      }

      retain_rule {
        count = 7
      }
    }
  }
}
