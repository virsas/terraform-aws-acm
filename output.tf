output "id" {
  description = "The ID of the ACM certificate."
  value       = try(aws_acm_certificate.vss[0].id, null)
}

output "arn" {
  description = "The ARN of the ACM certificate."
  value       = try(aws_acm_certificate.vss[0].arn, null)
}

output "domain_name" {
  description = "The domain name of the ACM certificate."
  value       = try(aws_acm_certificate.vss[0].domain_name, null)
}

output "status" {
  description = "The status of the ACM certificate."
  value       = try(aws_acm_certificate.vss[0].status, null)
}

output "validation_emails" {
  description = "List of email addresses to which validation emails were sent."
  value       = try(aws_acm_certificate.vss[0].validation_emails, [])
}

output "domain_validation_options" {
  description = "List of domain validation options created by ACM."
  value       = try(aws_acm_certificate.vss[0].domain_validation_options, [])
}

output "validation_domains" {
  description = "List of processed validation domains."
  value       = local.validation_domains
}