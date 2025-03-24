//KMS shared for all buckets
resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
resource "aws_kms_alias" "s3" {
  name          = "alias/s3-key-alias"
  target_key_id = aws_kms_key.s3.key_id
}

#Logs bucket
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "demo-arch-logs-bucket"

  force_destroy = true
}
resource "aws_s3_bucket_versioning" "logs_versioning" {
    bucket = aws_s3_bucket.logs_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "logs_sse" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle"{
    bucket = aws_s3_bucket.logs_bucket.id
    rule {
        id = "logs-expiration"

        expiration {
            days = 90
        }

        status = "Enabled"

        transition {
        days          = 30
        storage_class = "STANDARD_IA"
        }

        transition {
        days          = 90
        storage_class = "GLACIER"
        }
    }
}

#Main secure bucket
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "demo-arch-bucket"
  force_destroy = true
}
resource "aws_s3_bucket_logging" "secure_bucket_logging" {
    bucket = aws_s3_bucket.secure_bucket.id
    target_bucket = aws_s3_bucket.logs_bucket.id
    target_prefix = "access-logs/"
}
resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
    bucket = aws_s3_bucket.secure_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_sse" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "secure_bucket_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "secure_bucket_policy" {
  bucket = aws_s3_bucket.secure_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyUnEncryptedTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "${aws_s3_bucket.secure_bucket.arn}",
          "${aws_s3_bucket.secure_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
