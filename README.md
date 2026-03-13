# terraform-aws-s3

A Terraform module for creating secure, production-ready Amazon S3 buckets with configurable options.

## Features

- Server-side encryption (AES256 or KMS)
- Versioning enabled by default
- Block public access (all settings)
- Optional access logging to another bucket
- Optional CORS rules
- Optional Lifecycle rules (expiration, transition)
- Optional Object Lock support
  - `object_lock_enabled` must be true at creation
  - Default retention (`object_lock_configuration`) is optional
- Force destroy option
- Full tagging support

## Usage

Simple usage

```hcl
module "s3_bucket" {
  source = "github.com/asaphe/terraform-aws-s3?ref=v1.0.0"

  bucket_name = "example-bucket"
  tags = {
    Environment = "dev"
  }
}
```

Enable Object Locking (no default retention)

```hcl
module "s3_bucket" {
  source = "github.com/asaphe/terraform-aws-s3?ref=v1.0.0"

  bucket_name          = "locked-bucket"
  object_lock_enabled  = true
}
```

Enable Object Locking with Retention

```hcl
module "s3_bucket" {
  source = "github.com/asaphe/terraform-aws-s3?ref=v1.0.0"

  bucket_name          = "locked-bucket-with-retention"
  object_lock_enabled  = true

  object_lock_configuration = {
    rule = {
      default_retention = {
        mode  = "GOVERNANCE"
        days  = 30
      }
    }
  }
}
```

Enable Access Logging

```hcl
module "s3_bucket" {
  source = "github.com/asaphe/terraform-aws-s3?ref=v1.0.0"

  bucket_name = "my-logged-bucket"

  logging = {
    target_bucket = "logs-bucket"
    target_prefix = "s3-logs/"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| bucket_name | The name of the S3 bucket | `string` | - | yes |
| force_destroy | Whether to force destroy the bucket (deletes all objects) | `bool` | `false` | no |
| tags | A map of tags to assign to the bucket | `map(string)` | `{}` | no |
| versioning_enabled | Whether to enable bucket versioning | `bool` | `true` | no |
| sse_algorithm | Server-side encryption algorithm (AES256 or aws:kms) | `string` | `"AES256"` | no |
| kms_key_encryption | Whether to use KMS key encryption | `bool` | `false` | no |
| bucket_key_enabled | Whether to enable S3 Bucket Keys for SSE-KMS | `bool` | `false` | no |
| expected_bucket_owner | Account ID of the expected bucket owner | `string` | `null` | no |
| block_public_acls | Block public ACLs for this bucket | `bool` | `true` | no |
| block_public_policy | Block public bucket policies for this bucket | `bool` | `true` | no |
| ignore_public_acls | Ignore public ACLs for this bucket | `bool` | `true` | no |
| restrict_public_buckets | Restrict public bucket policies for this bucket | `bool` | `true` | no |
| logging | Access logging configuration (target_bucket, target_prefix) | `object` | `null` | no |
| cors_rules | List of CORS rules for the bucket | `list(object)` | `[]` | no |
| lifecycle_rules | List of lifecycle rules (transitions, expiration, etc.) | `list(object)` | `[]` | no |
| object_lock_enabled | Enable object locking (must be set at bucket creation) | `bool` | `false` | no |
| object_lock_configuration | Object lock default retention configuration | `object` | `null` | no |
| request_payer | Who pays for requests: BucketOwner or Requester | `string` | `"BucketOwner"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |

## Resources Created

| Resource | File | Description |
|----------|------|-------------|
| `aws_s3_bucket` | main.tf | The S3 bucket with CORS and logging |
| `aws_s3_bucket_versioning` | versioning.tf | Bucket versioning configuration |
| `aws_s3_bucket_server_side_encryption_configuration` | sse.tf | Server-side encryption (+ optional KMS key) |
| `aws_s3_bucket_public_access_block` | public_access.tf | Public access block settings |
| `aws_s3_bucket_lifecycle_configuration` | lifecycle_rules.tf | Lifecycle rules (conditional) |
| `aws_s3_bucket_object_lock_configuration` | object_lock.tf | Object lock retention (conditional) |
| `aws_s3_bucket_request_payment_configuration` | request_payment.tf | Request payment config (conditional) |

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.
