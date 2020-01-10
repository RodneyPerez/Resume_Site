resource "aws_route53_record" "redirect" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.www_domain_name
  type    = "A"

  alias {
    name                   = aws_route53_zone.main.name
    zone_id                = aws_route53_record.main.zone_id
    evaluate_target_health = false
  }
}

