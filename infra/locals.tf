locals {
  s3_origin_id    = "cloudfront-distribution-origin-${var.domain_name}.s3.amazonaws.com"
  www_domain_name = "www.${var.domain_name}"
}
