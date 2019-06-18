resource "tls_private_key" "client" {
  algorithm   = "${var.ca_algorithm}"
  ecdsa_curve = "${var.ca_ecdsa_curve}"
}

resource "tls_cert_request" "client" {
  key_algorithm   = "${tls_private_key.client.algorithm}"
  private_key_pem = "${tls_private_key.client.private_key_pem}"

  subject {
    common_name = "${var.cert_client_name}"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem = "${tls_cert_request.client.cert_request_pem}"

  ca_key_algorithm   = "${var.ca_algorithm}"
  ca_private_key_pem = "${var.ca_private_key_pem}"
  ca_cert_pem        = "${var.ca_certificate_pem}"

  validity_period_hours = "${var.cert_validity_period_days * 24}"
  early_renewal_hours   = "${var.cert_early_renewal_days * 24}"

  allowed_uses = ["client_auth", "digital_signature"]
}

data "template_file" "ovpn_client_config" {
  vars = {
    vpn_endpoint = "${var.vpn_endpoint}"
    vpn_port     = "${var.vpn_port}"
    ca_pem       = "${var.ca_certificate_pem}"
    cert_pem     = "${tls_locally_signed_cert.client.cert_pem}"
    key_pem      = "${tls_private_key.client.private_key_pem}"
  }

  template = "${file("${path.module}/templates/ovpn_client.conf")}"
}
