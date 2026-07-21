output "id" {
  value = aws_acm_certificate.vss[0].id
}
output "arn" {
  value = aws_acm_certificate.vss[0].arn
}
output "domain_name" {
  value = aws_acm_certificate.vss[0].domain_name
}
output "status" {
  value = aws_acm_certificate.vss[0].status
}
output "validation_emails" {
  value = aws_acm_certificate.vss[0].validation_emails
}
output "domain_validation_options" {
  value = aws_acm_certificate.vss[0].domain_validation_options
}
output "validation_domains" {
  value = local.validation_domains
}