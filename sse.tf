resource "aws_kms_key" "this" {
  count = var.kms_key_encryption ? 1 : 0

  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10

  tags = var.tags
}


resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = var.expected_bucket_owner

  rule {
    bucket_key_enabled = var.kms_key_encryption ? var.bucket_key_enabled : null

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_key_encryption ? aws_kms_key.this[0].arn : null
    }
  }
}
