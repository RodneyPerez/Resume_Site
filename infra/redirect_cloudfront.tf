locals {
  s3_redirect_origin_id = "S3-${var.www_domain_name}.s3.amazonaws.com"
}
resource "aws_cloudfront_distribution" "redirect" {
  origin {
    domain_name = "${aws_s3_bucket.redirect.website_endpoint}"
    origin_id   = "${local.s3_redirect_origin_id}"

    custom_origin_config {
      http_port               = 80
      https_port              = 443
      origin_protocol_policy  = "http-only"
      origin_ssl_protocols    = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }

    custom_header {
      name  = "User-Agent"
      value = "${var.secret}"
    }
  }

  comment             = "CDN for ${var.www_domain_name} S3 Bucket"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["${var.www_domain_name}"]
  depends_on          = ["aws_s3_bucket.main"]


  default_cache_behavior {
    target_origin_id = "${local.s3_redirect_origin_id}"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn       = "${aws_acm_certificate_validation.default.certificate_arn}"
    ssl_support_method        = "sni-only"
    minimum_protocol_version  = "TLSv1.1_2016"
  }

  tags = "${var.redirect_tags}"
}
