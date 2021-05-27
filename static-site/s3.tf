# S3 bucket for website.
resource "aws_s3_bucket" "root_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"
  policy = templatefile("s3-policy/s3-policy.json", { bucket = "www.${var.bucket_name}" })

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = var.common_tags
}

resource "null_resource" "upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/s3Contents s3://${aws_s3_bucket.root_bucket.id}"
  }
}