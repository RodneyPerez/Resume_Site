resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect" {
  zone_id = aws_route53_zone.main.zone_id
  name    = local.www_domain_name
  type    = "A"

  alias {
    name                   = aws_route53_zone.main.name
    zone_id                = aws_route53_record.main.zone_id
    evaluate_target_health = false
  }
}
