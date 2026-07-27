locals {
  distinct_domains = distinct([
    for d in concat(
      var.cert_domain != null ? [var.cert_domain] : [],
      coalesce(var.cert_alts, [])
    ) : replace(d, "*.", "")
  ])
  validation_domains = distinct([
    for k, v in try(aws_acm_certificate.vss[0].domain_validation_options, []) : merge(
      tomap(v), { domain_name = replace(v.domain_name, "*.", "") }
    )
  ])
  options = var.import_cert ? [] : [1]
}

resource "aws_acm_certificate" "vss" {
  count = var.create_cert || var.import_cert ? 1 : 0

  domain_name               = var.create_cert && !var.import_cert ? var.cert_domain : null
  subject_alternative_names = var.create_cert && !var.import_cert && length(coalesce(var.cert_alts, [])) > 0 ? var.cert_alts : null
  validation_method         = var.create_cert && !var.import_cert ? var.validation : null

  certificate_body  = var.import_cert && !var.create_cert ? file("${var.cert_path}/${var.cert_name}.crt") : null
  private_key       = var.import_cert && !var.create_cert ? file("${var.cert_path}/${var.cert_name}.key") : null
  certificate_chain = var.import_cert && !var.create_cert ? file("${var.cert_path}/${var.cert_name}-ca.crt") : null

  dynamic "options" {
    for_each = local.options
    content {
      certificate_transparency_logging_preference = "ENABLED"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "vss" {
  count = var.validation == "DNS" && var.zone != "" ? length(local.distinct_domains) : 0

  provider = aws.master_provider

  zone_id = var.zone
  name    = element(local.validation_domains, count.index)["resource_record_name"]
  type    = element(local.validation_domains, count.index)["resource_record_type"]
  ttl     = var.ttl

  records = [
    element(local.validation_domains, count.index)["resource_record_value"]
  ]

  allow_overwrite = true

  depends_on = [aws_acm_certificate.vss]
}
