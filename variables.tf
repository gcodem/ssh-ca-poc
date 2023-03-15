variable "credentials" {
  type        = string
  description = "Path to the JSON file with the service account credentials."
}

variable "ssh_key" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "kms_keyring" {
  type        = string
  default     = "vault-gevorg6"
  description = "Name of the GCP KMS keyring"
}

variable "kms_crypto_key" {
  type        = string
  default     = "vault-gevorg-init6"
  description = "Name of the GCP KMS crypto key"
}

variable "load_balancing_scheme" {
  type        = string
  default     = "EXTERNAL"
  description = "e.g. [INTERNAL|EXTERNAL]. Scheme of the load balancer"
}

variable "allow_public_egress" {
  type        = bool
  default     = true
  description = "Whether to create a NAT for external egress. If false, you must also specify an http_proxy to download required executables including Vault, Fluentd and Stackdriver"
}