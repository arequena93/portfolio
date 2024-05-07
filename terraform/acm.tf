resource "aws_acm_certificate" "personal_web_portfolio_cert" {
  domain_name       = "antonirs.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  zone_id = data.aws_route53_zone.my_personal_zone.zone_id
  name    = tolist(aws_acm_certificate.personal_web_portfolio_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.personal_web_portfolio_cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.personal_web_portfolio_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.personal_web_portfolio_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
