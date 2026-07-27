# Terraform AWS ACM Module

A Terraform module for managing AWS Certificate Manager (ACM) SSL/TLS certificates. This module supports requesting new ACM certificates validated via **DNS** (with automatic Route53 record creation) or **EMAIL**, as well as **importing existing certificates** from local files.

---

## Features

- **New Certificate Requests**: Create public ACM certificates for a domain and optional Subject Alternative Names (SANs).
- **DNS Validation**: Automatically creates required CNAME validation records in Route53 when a hosted zone ID is provided.
- **Email Validation**: Supports standard ACM email-based domain validation.
- **Certificate Import**: Import third-party certificates, private keys, and CA chains directly from local files.
- **Wildcard Domains**: Built-in normalization for wildcard domain names (e.g., `*.example.com`).
- **Certificate Transparency**: Enables certificate transparency logging by default for newly created certificates.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | `>= 1.0` |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | `~> 5.0` |

---

## Providers

| Name | Version | Notes |
|------|---------|-------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | `~> 5.0` | Primary provider for ACM resources. |
| <a name="provider_aws.master_provider"></a> [aws.master_provider](#provider\_aws.master\_provider) | `~> 5.0` | Provider alias used to create Route53 DNS validation records. |

> [!NOTE]  
> This module requires passing the `aws.master_provider` provider explicitly via `providers = { aws.master_provider = aws }` or using a dedicated provider configuration for cross-account Route53 zone management.

---

## Usage & Examples

### Example 1: ACM Certificate with Route53 DNS Validation (Recommended)

Automatically creates the ACM certificate and provisions the DNS validation CNAME records in Route53.

```hcl
provider "aws" {
  region = "us-east-1"
}

module "acm" {
  source = "./terraform-aws-acm"

  providers = {
    aws.master_provider = aws
  }

  create_cert = true
  cert_domain = "example.com"
  validation  = "DNS"
  zone        = "Z123456789ABCDEF"
  ttl         = 30
}
```

---

### Example 2: ACM Certificate with Email Validation

Requests an ACM certificate using Email validation. ACM sends approval emails to domain contacts.

```hcl
provider "aws" {
  region = "us-east-1"
}

module "acm_email" {
  source = "./terraform-aws-acm"

  providers = {
    aws.master_provider = aws
  }

  create_cert = true
  cert_domain = "example.com"
  validation  = "EMAIL"
}
```

---

### Example 3: Importing an Existing Certificate from Local Files

Imports an existing certificate file (`.crt`), private key (`.key`), and CA chain (`-ca.crt`) from a local directory.

Given the following files in `./certs/acm`:
- `my-cert.crt`
- `my-cert.key`
- `my-cert-ca.crt`

```hcl
provider "aws" {
  region = "us-east-1"
}

module "acm_import" {
  source = "./terraform-aws-acm"

  providers = {
    aws.master_provider = aws
  }

  create_cert = false
  import_cert = true
  cert_path   = "./certs/acm"
  cert_name   = "my-cert"
}
```

---

### Example 4: Certificate with Wildcard Domain and Subject Alternative Names (SANs)

Creates a certificate for `example.com`, wildcard `*.example.com`, and additional subdomains.

```hcl
provider "aws" {
  region = "us-east-1"
}

module "acm_wildcard" {
  source = "./terraform-aws-acm"

  providers = {
    aws.master_provider = aws
  }

  create_cert = true
  cert_domain = "example.com"
  cert_alts   = [
    "*.example.com",
    "api.sub.example.com"
  ]
  validation  = "DNS"
  zone        = "Z123456789ABCDEF"
}
```

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_cert"></a> [create\_cert](#input\_create\_cert) | Controls whether to request a new ACM certificate. Set to `false` if importing or disabling certificate creation. | `bool` | `true` | no |
| <a name="input_import_cert"></a> [import\_cert](#input\_import\_cert) | Controls whether to import an existing certificate from local files specified by `cert_path` and `cert_name`. | `bool` | `false` | no |
| <a name="input_cert_path"></a> [cert\_path](#input\_cert\_path) | Directory path containing certificate files (`<cert_name>.crt`, `<cert_name>.key`, and `<cert_name>-ca.crt`) when importing. | `string` | `"./certs/acm"` | no |
| <a name="input_cert_name"></a> [cert\_name](#input\_cert\_name) | Base file name (without extension) for certificate files when importing (e.g., `"example"`). | `string` | `null` | no |
| <a name="input_cert_domain"></a> [cert\_domain](#input\_cert\_domain) | Primary Fully Qualified Domain Name (FQDN) for the certificate (e.g., `"example.com"` or `"*.example.com"`). | `string` | `null` | no |
| <a name="input_cert_alts"></a> [cert\_alts](#input\_cert\_alts) | List of Subject Alternative Names (SANs) for the ACM certificate. | `list(string)` | `[]` | no |
| <a name="input_validation"></a> [validation](#input\_validation) | Validation method for the certificate. Allowed values: `"DNS"` or `"EMAIL"`. | `string` | `"EMAIL"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Route53 Hosted Zone ID used to automatically create DNS validation records when `validation = "DNS"`. | `string` | `""` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | Time-To-Live (TTL) in seconds for Route53 DNS validation records. | `number` | `30` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the ACM certificate. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the ACM certificate. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The domain name of the ACM certificate. |
| <a name="output_status"></a> [status](#output\_status) | The status of the ACM certificate (e.g. `PENDING_VALIDATION`, `ISSUED`). |
| <a name="output_validation_emails"></a> [validation\_emails](#output\_validation\_emails) | List of email addresses to which validation emails were sent when using EMAIL validation. |
| <a name="output_domain_validation_options"></a> [domain\_validation\_options](#output\_domain\_validation\_options) | List of domain validation options created by ACM for DNS record creation. |
| <a name="output_validation_domains"></a> [validation\_domains](#output\_validation\_domains) | Processed validation domain details. |

---

## License

MIT License. See [LICENSE](file:///Users/stefan/Work/virsas/mod/terraform/terraform-aws-acm/LICENSE) for details.
