resource "aws_s3_bucket" "main" {
  bucket = var.domain_name
  acl    = "private"
  logging {
    target_bucket = aws_s3_bucket.logs.bucket
    target_prefix = "${var.domain_name}/"
  }
  tags = var.main_tags
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.main.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.domain_name}-site-logs"
  acl    = "log-delivery-write"
  tags   = var.main_tags
}

