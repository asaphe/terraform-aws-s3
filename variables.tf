variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket (deletes all objects)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "logging" {
  description = "Access logging configuration for the bucket."
  type = object({
    target_bucket = string
    target_prefix = optional(string)
  })
  default = null
}

variable "cors_rules" {
  description = "List of CORS rules for the bucket."
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the bucket."
  type = list(object({
    id      = string
    enabled = bool
    filter = optional(object({
      prefix = optional(string)
    }))
    transition = optional(list(object({
      days          = optional(number)
      storage_class = string
    })))
    expiration = optional(object({
      days = optional(number)
    }))
    noncurrent_version_expiration = optional(object({
      noncurrent_days = number
    }))
    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))
  }))
  default = []
}

variable "versioning_enabled" {
  description = "Whether to enable bucket versioning."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use (AES256 or aws:kms)."
  type        = string
  default     = "AES256"
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "object_lock_enabled" {
  description = "Enable object locking for the S3 bucket. Must be set at bucket creation. Cannot be disabled later."
  type        = bool
  default     = false
}

variable "object_lock_configuration" {
  description = "Optional object lock configuration. Only required if you want default retention rules."
  type = object({
    rule = object({
      default_retention = object({
        mode  = string # "COMPLIANCE" or "GOVERNANCE"
        days  = optional(number)
        years = optional(number)
      })
    })
  })
  default = null
}

variable "kms_key_encryption" {
  description = "(Optional) Whether to use KMS key encryption. Defaults to false."
  type        = bool
  default     = false
}

variable "expected_bucket_owner" {
  description = "(Optional) The account ID of the expected bucket owner."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Whether to enable S3 Bucket Keys for SSE-KMS. Defaults to false. Only relevant if using aws:kms."
  type        = bool
  default     = false
}

variable "request_payer" {
  description = "Specifies who pays for requests and data transfer. Valid values: 'BucketOwner' or 'Requester'."
  type        = string
  default     = "BucketOwner"
}
