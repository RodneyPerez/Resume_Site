resource "aws_s3_bucket" "main" {
  bucket = var.domain_name
  acl    = "private"
  logging {
    target_bucket = aws_s3_bucket.logs.bucket
    target_prefix = "${var.domain_name}/"
  }
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags = var.main_tags
}

data "aws_iam_policy_document" "read_with_secret" {
  statement {
    sid       = "1"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:UserAgent"
      values   = [var.secret]
    }
  }
}

resource "aws_s3_bucket_policy" "read_with_secret" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.read_with_secret.json
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.domain_name}-site-logs"
  acl    = "log-delivery-write"
  tags   = var.main_tags
}

