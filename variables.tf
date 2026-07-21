variable "create_cert" {
  description           = "Whether to import an existing certificate. If 'true', set 'create_cert' to 'false' and provide the certificate name in 'cert_name'. Defaults to false."
  type                  = bool
  default               = true
}

variable "import_cert" {
  description           = "For import, please set this value to true, disable creation and provide the name of the cert in cert object."
  type                  = bool
  default               = false
}

variable "cert_path" {
  description           = "The directory containing the certificate files (.crt, .key, -ca.crt). Defaults to './certs/acm'."
  type                  = string
  default               = "./certs/acm"
}

variable "cert_name" {
  description           = "The name of the certificate."
  type                  = string
  default               = null
}

variable "cert_domain" {
  description           = "The main domain name for the certificate."
  type                  = string
  default               = null
}

variable "cert_alts" {
  description           = "A list of alternative domain names for the certificate."
  type                  = list(string)
  default               = null
}

variable "validation" {
  description           = "The method to validate the certificate ('DNS' or 'EMAIL'). If 'DNS', provide the 'zone' variable. Defaults to 'EMAIL'."
  type                  = string
  default               = "EMAIL"

  validation {
    condition           = contains(["DNS", "EMAIL"], var.validation)
    error_message       = "Invalid validation method. Allowed values: DNS, EMAIL."
  }
}

variable "zone" {
  description           = "The Route53 zone ID if using 'DNS' validation."
  type                  = string
  default               = ""
}

variable "ttl" {
  description           = "The TTL (Time-to-Live) for Route53 records in seconds. Defaults to 30 seconds."
  type                  = string
  default               = "30"
}