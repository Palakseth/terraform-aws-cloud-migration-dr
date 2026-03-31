# ================================
# Random ID (for unique bucket name)
# ================================
resource "random_id" "rand" {
  byte_length = 4
}

# ================================
# S3 Bucket (Backup Storage)
# ================================
resource "aws_s3_bucket" "backup" {
  bucket = "${var.project_name}-backup-${random_id.rand.hex}"

  tags = {
    Name = "${var.project_name}-backup"
  }
}

# ================================
# Enable Versioning (VERY IMPORTANT)
# ================================
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ================================
# Lifecycle (ADD THIS BELOW)
# ================================
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.backup.id

  rule {
    id     = "cleanup-old"
    status = "Enabled"

    filter {}   # 👈 ADD THIS LINE

    expiration {
      days = 30
    }
  }
}
