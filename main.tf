resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled

  tags = merge(
    var.tags,
    {
      "Name" = var.bucket_name
    }
  )

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }

  dynamic "logging" {
    for_each = var.logging != null ? [var.logging] : []
    content {
      target_bucket = logging.value.target_bucket
      target_prefix = try(logging.value.target_prefix, null)
    }
  }
}
