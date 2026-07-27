variable "create_cert" {
  description = "Controls whether to request a new ACM certificate. Set to false if importing an existing certificate or disabling certificate creation."
  type        = bool
  default     = true
}

variable "import_cert" {
  description = "Controls whether to import an existing certificate from local files specified by 'cert_path' and 'cert_name'. Set to true when importing."
  type        = bool
  default     = false
}

variable "cert_path" {
  description = "Directory path containing the certificate files (<cert_name>.crt, <cert_name>.key, and <cert_name>-ca.crt) when importing an existing certificate."
  type        = string
  default     = "./certs/acm"
}

variable "cert_name" {
  description = "Base file name (without extension) for the certificate files when importing (e.g., 'example' for 'example.crt', 'example.key', 'example-ca.crt')."
  type        = string
  default     = null
}

variable "cert_domain" {
  description = "Primary Fully Qualified Domain Name (FQDN) for the ACM certificate (e.g., 'example.com' or '*.example.com')."
  type        = string
  default     = null
}

variable "cert_alts" {
  description = "List of Subject Alternative Names (SANs) for the ACM certificate (e.g., ['sub.example.com', 'app.example.com'])."
  type        = list(string)
  default     = []
}

variable "validation" {
  description = "Validation method for the certificate. Allowed values: 'DNS' or 'EMAIL'. Required when creating a new certificate."
  type        = string
  default     = "EMAIL"

  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation)
    error_message = "Validation method must be either 'DNS' or 'EMAIL'."
  }
}

variable "zone" {
  description = "Route53 Hosted Zone ID used to automatically create DNS validation records when 'validation' is set to 'DNS'."
  type        = string
  default     = ""
}

variable "ttl" {
  description = "Time-To-Live (TTL) in seconds for Route53 DNS validation records."
  type        = number
  default     = 30

  validation {
    condition     = var.ttl > 0
    error_message = "TTL must be a positive number greater than 0."
  }
}