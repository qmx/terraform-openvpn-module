output "server_cidr" {
  value = "${var.server_cidr}"
}

output "server_config" {
  value = "${data.template_file.ovpn_server_config.rendered}"
}

output "ca_algorithm" {
  value = "${tls_private_key.ca.algorithm}"
}

output "ca_ecdsa_curve" {
  value = "${tls_private_key.ca.ecdsa_curve}"
}

output "ca_certificate_pem" {
  value = "${tls_self_signed_cert.ca.cert_pem}"
}

output "ca_private_key_pem" {
  value = "${tls_private_key.ca.private_key_pem}"
}

output "vpn_endpoint" {
  value = "${var.vpn_endpoint}"
}

output "vpn_port" {
  value = "${var.vpn_port}"
}
