variable vpn_endpoint {}
variable vpn_port {}
variable ca_algorithm {}
variable ca_ecdsa_curve {}
variable ca_certificate_pem {}
variable ca_private_key_pem {}
variable cert_client_name {}

variable cert_validity_period_hours {
  default = 240
}

variable cert_early_renewal_hours {
  default = 200
}
