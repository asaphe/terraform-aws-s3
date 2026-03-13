resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = var.object_lock_configuration != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode  = var.object_lock_configuration.rule.default_retention.mode
      days  = try(var.object_lock_configuration.rule.default_retention.days, null)
      years = try(var.object_lock_configuration.rule.default_retention.years, null)
    }
  }
}
