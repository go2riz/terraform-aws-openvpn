resource "aws_s3_bucket" "vpn" {
  bucket_prefix = "openvpn-${var.name}-"
  force_destroy = var.s3_force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "vpn" {
  bucket = aws_s3_bucket.vpn.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "vpn" {
  bucket = aws_s3_bucket.vpn.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "vpn" {
  bucket = aws_s3_bucket.vpn.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpn" {
  bucket = aws_s3_bucket.vpn.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}
