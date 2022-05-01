variable "src_lambda" {
  description = "Common Lambda source directory"
  default     = "files/lambda"
}

variable "src_dir" {
  description = "Source directory for function (within $${var.src_lambda})"
}

variable "src" {
  description = "Script name without extension"
}

variable "src_ext" {
  description = "Script extension"
}

variable "dst" {
  description = "Common Lambda dest directory"
  default     = "bundles"
}

variable "dst_s3_id" {
  description = "S3 bucket Id function is uploaded to"
}

variable "local_hash" {
  description = "Hash on main script to trigger updates"
}

