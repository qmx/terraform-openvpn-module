variable server_cidr {}
variable vpn_endpoint {}
variable vpn_port {}

variable additional_routes {
  type        = "list"
  default     = []
  description = "additional routes to be pushed to the client (using CIDR notation"
}
