variable vpn_endpoint {}
variable vpn_port {}
variable ca_algorithm {}
variable ca_ecdsa_curve {}
variable ca_certificate_pem {}
variable ca_private_key_pem {}
variable cert_client_name {}

variable cert_validity_period_days {
  default     = 90
  description = "certificate validity, in days"
}

variable cert_early_renewal_days {
  default     = 60
  description = "early certificate renewal, in days"
}
