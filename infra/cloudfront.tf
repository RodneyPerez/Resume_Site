locals {
  s3_origin_id = "cloudfront-distribution-origin-${var.domain_name}.s3.amazonaws.com"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Meant to allow cloudfront to have access to s3 bucket"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.main.bucket_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  comment             = "CDN for ${var.domain_name} S3 Bucket"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.domain_name, var.www_domain_name]
  depends_on          = [aws_s3_bucket.main]

  default_cache_behavior {
    target_origin_id = local.s3_origin_id
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
    acm_certificate_arn      = aws_acm_certificate_validation.default.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  tags = var.main_tags
}

