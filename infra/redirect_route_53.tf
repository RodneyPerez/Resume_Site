resource "aws_route53_record" "redirect" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.www_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.redirect.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}
