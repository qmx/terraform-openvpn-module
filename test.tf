module "openvpn_server" {
  source            = "./server"
  vpn_port          = 1194
  server_cidr       = "10.23.0.0/29"
  additional_routes = []
  vpn_endpoint      = "openvpn"
}

resource "local_file" "server_conf" {
  sensitive_content = "${module.openvpn_server.server_config}"
  filename          = "${path.module}/server.ovpn"
}

module "openvpn_client_c1" {
  source             = "./client"
  vpn_endpoint       = "${module.openvpn_server.vpn_endpoint}"
  vpn_port           = "${module.openvpn_server.vpn_port}"
  ca_certificate_pem = "${module.openvpn_server.ca_certificate_pem}"
  ca_private_key_pem = "${module.openvpn_server.ca_private_key_pem}"
  ca_ecdsa_curve     = "${module.openvpn_server.ca_ecdsa_curve}"
  ca_algorithm       = "${module.openvpn_server.ca_algorithm}"
  cert_client_name   = "c1"
}

module "openvpn_client_c2" {
  source             = "./client"
  vpn_endpoint       = "${module.openvpn_server.vpn_endpoint}"
  vpn_port           = "${module.openvpn_server.vpn_port}"
  ca_certificate_pem = "${module.openvpn_server.ca_certificate_pem}"
  ca_private_key_pem = "${module.openvpn_server.ca_private_key_pem}"
  ca_ecdsa_curve     = "${module.openvpn_server.ca_ecdsa_curve}"
  ca_algorithm       = "${module.openvpn_server.ca_algorithm}"
  cert_client_name   = "c2"
}


resource "local_file" "c1_conf" {
  sensitive_content = "${module.openvpn_client_c1.client_config}"
  filename          = "${path.module}/c1.ovpn"
}

resource "local_file" "c2_conf" {
  sensitive_content = "${module.openvpn_client_c2.client_config}"
  filename          = "${path.module}/c2.ovpn"
}
