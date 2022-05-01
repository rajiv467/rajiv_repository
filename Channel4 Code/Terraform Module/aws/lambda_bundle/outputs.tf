output "src_hash" {
  value = null_resource.hash.triggers.src_hash
}

output "s3_key" {
  value = aws_s3_bucket_object.upload.key
}

output "s3_etag" {
  value = aws_s3_bucket_object.upload.etag
}

