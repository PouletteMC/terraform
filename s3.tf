resource "aws_s3_bucket" "website" {
  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name = "s3-${var.account_name}"
  }
}

resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  depends_on = [aws_s3_bucket_public_access_block.website]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "txt_file" {
  bucket       = aws_s3_bucket.website.id
  key          = "hello.txt"
  source       = "${path.module}/files/hello.txt"
  etag         = filemd5("${path.module}/files/hello.txt")
  content_type = "text/plain"

  depends_on = [aws_s3_bucket_versioning.website]
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "${path.module}/files/index.html"
  etag         = filemd5("${path.module}/files/index.html")
  content_type = "text/html"

  depends_on = [aws_s3_bucket_versioning.website]
}

resource "aws_s3_bucket_lifecycle_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  depends_on = [aws_s3_bucket_versioning.website]

  rule {
    id     = "lifecycle-${var.account_name}"
    status = "Enabled"

    filter {}

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}
