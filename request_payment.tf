resource "aws_s3_bucket_request_payment_configuration" "this" {
  count = var.request_payer != null ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = var.expected_bucket_owner
  payer                 = var.request_payer
}
