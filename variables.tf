variable "name" {
  description = "Your Name"
  type        = string
}

variable "team" {
  description = "Your Team"
  type        = string
}

variable "bucket_name_prefix" {
  description = "Prefix to the name of the S3 Bucket (lowercase letters only). A random string will be appended to make the name globally unique"
  type        = string

  validation {
    condition     = can(regex("^[a-z-]+$", var.bucket_name_prefix))
    error_message = "Prefix for the bucket name can only contain lowercase letters and hyphens."
  }
}
