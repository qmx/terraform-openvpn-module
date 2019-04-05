resource "tls_private_key" "ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm         = "${tls_private_key.ca.algorithm}"
  private_key_pem       = "${tls_private_key.ca.private_key_pem}"
  validity_period_hours = 14400
  early_renewal_hours   = 10800
  is_ca_certificate     = true

  allowed_uses = ["cert_signing"]

  subject {
    common_name = "openvpn ca"
  }
}

resource "tls_private_key" "server" {
  algorithm   = "${tls_private_key.ca.algorithm}"
  ecdsa_curve = "${tls_private_key.ca.ecdsa_curve}"
}

resource "tls_cert_request" "server" {
  key_algorithm   = "${tls_private_key.server.algorithm}"
  private_key_pem = "${tls_private_key.server.private_key_pem}"

  subject {
    common_name = "server"
  }
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem = "${tls_cert_request.server.cert_request_pem}"

  ca_key_algorithm   = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = "${var.cert_validity_period_days * 24}"
  early_renewal_hours   = "${var.cert_early_renewal_days * 24}"

  allowed_uses = ["server_auth", "digital_signature", "key_encipherment"]
}

data "template_file" "additional_routes" {
  vars {
    network = "${element(split("/", "${var.additional_routes[count.index]}"), 0)}"
    netmask = "${cidrnetmask(var.additional_routes[count.index])}"
  }

  count    = "${length(var.additional_routes)}"
  template = "${file("${path.module}/templates/route.tmpl")}"
}

data "template_file" "ovpn_server_config" {
  vars {
    ca_pem            = "${tls_self_signed_cert.ca.cert_pem}"
    cert_pem          = "${tls_locally_signed_cert.server.cert_pem}"
    key_pem           = "${tls_private_key.server.private_key_pem}"
    server_network    = "${element(split("/", "${var.server_cidr}"), 0)}"
    server_netmask    = "${cidrnetmask("${var.server_cidr}")}"
    additional_routes = "${join("", data.template_file.additional_routes.*.rendered)}"
  }

  template = "${file("${path.module}/templates/ovpn_server.conf")}"
}
