resource "aws_s3_bucket" "redirect" {
  bucket = "${var.www_domain_name}"
  acl    = "private"
  website {
    redirect_all_requests_to = "https://${var.domain_name}"
  }
  tags   = "${var.redirect_tags}"
}

data "aws_iam_policy_document" "redirect_read_with_secret" {
  statement {
    sid       = "1"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.redirect.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test = "StringEquals"
      variable = "aws:UserAgent"
      values = ["${var.secret}"]
    }
  }
}

resource "aws_s3_bucket_policy" "redirect_read_with_secret" {
  bucket = "${aws_s3_bucket.redirect.id}"
  policy = "${data.aws_iam_policy_document.redirect_read_with_secret.json}"
}
