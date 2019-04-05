variable server_cidr {}
variable vpn_endpoint {}
variable vpn_port {}

variable cert_validity_period_days {
  default     = 90
  description = "certificate validity, in days"
}

variable cert_early_renewal_days {
  default     = 60
  description = "early certificate renewal, in days"
}

variable additional_routes {
  type        = "list"
  default     = []
  description = "additional routes to be pushed to the client (using CIDR notation"
}
