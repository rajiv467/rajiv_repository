/* Bundle and put Lambda function in S3:
1. cd to lambda src dir and create zip.
2. Get hash from source bundle (to trigger rebuilds of function).
3. Copy zip to S3.
*/

# Create a local zip of the lambda funtion
resource "null_resource" "bundle" {
  triggers = {
    local_hash = var.local_hash
    src_dir    = "${abspath(path.root)}/${var.src_lambda}/${var.src_dir}"
    local_dst  = "${abspath(path.root)}/${var.src_lambda}/${var.dst}/${var.src_dir}.zip"
    s3_dst     = "${var.dst}/${var.src_dir}.zip"
  }

  provisioner "local-exec" {
    # -FS should create structure based on OS FS and not update anything new, replace anything prexisting
    # .[^.]* required to also add hidden files and folders
    # sh (Linux) does not like the dot pattern hence use of interpreter
    command     = "cd ${self.triggers.src_dir}; zip -r -FS ${self.triggers.local_dst} * .[^.]*"
    interpreter = ["/bin/bash", "-c"]
  }
}

# Get a hash of the local bundle
resource "null_resource" "hash" {
  triggers = {
    src_hash   = filebase64sha256(null_resource.bundle.triggers.local_dst)
    local_hash = var.local_hash
  }
}

# Upload zip to S3
resource "aws_s3_bucket_object" "upload" {
  bucket = var.dst_s3_id
  key    = null_resource.bundle.triggers.s3_dst
  source = null_resource.bundle.triggers.local_dst
  etag   = filemd5(null_resource.bundle.triggers.local_dst)
}
