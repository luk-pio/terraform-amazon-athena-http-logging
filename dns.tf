resource "aws_route53_zone" "production" {
  name = var.domain
}

resource "aws_route53domains_registered_domain" "example" {
  domain_name = var.domain

  dynamic "name_server" {
    for_each = aws_route53_zone.production.name_servers

    content {
      name = name_server.value
    }
  }
}

resource "fastly_tls_subscription" "example" {
  domains               = [for domain in fastly_service_vcl.test_domain.domain : domain.name]
  certificate_authority = "lets-encrypt"
}

resource "aws_route53_record" "domain_validation" {
  depends_on = [fastly_tls_subscription.example]

  for_each = {
    for domain in fastly_tls_subscription.example.domains :
    domain => element([
      for obj in fastly_tls_subscription.example.managed_dns_challenges :
      obj if obj.record_name == "_acme-challenge.${domain}"
    ], 0)
  }

  name            = each.value.record_name
  type            = each.value.record_type
  zone_id         = aws_route53_zone.production.zone_id
  allow_overwrite = true
  records         = [each.value.record_value]
  ttl             = 60
}

resource "fastly_tls_subscription_validation" "example" {
  subscription_id = fastly_tls_subscription.example.id
  depends_on      = [aws_route53_record.domain_validation]
}
data "fastly_tls_configuration" "default_tls" {
  default    = true
  depends_on = [fastly_tls_subscription_validation.example]
}

resource "aws_route53_record" "cname" {
  name    = local.subdomain
  records = [for record in data.fastly_tls_configuration.default_tls.dns_records : record.record_value if record.record_type == "CNAME"]
  ttl     = 300
  type    = "CNAME"
  zone_id = aws_route53_zone.production.zone_id
}
