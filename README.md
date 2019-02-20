# terraform-openvpn-module

A quick-and-dirty way of spinning up OpenVPN configuration files with a
throwaway CA structure.

This way you won't need to deal with easyrsa3 et al, and terraform will take
care of rotating the certificates for you.

## usage

```terraform
module "openvpn_server" {
  source            = "github.com/qmx/terraform-openvpn-module/server"
  vpn_endpoint      = "localhost"
  vpn_port          = "31194"
  server_cidr       = "10.23.0.0/29"
  additional_routes = ["10.22.44.0/24", "10.96.0.0/16"]
}

module "openvpn_client_workstation" {
  source             = "github.com/qmx/terraform-openvpn-module/client"
  vpn_endpoint       = "${module.openvpn_server.vpn_endpoint}"
  vpn_port           = "${module.openvpn_server.vpn_port}"
  ca_certificate_pem = "${module.openvpn_server.ca_certificate_pem}"
  ca_private_key_pem = "${module.openvpn_server.ca_private_key_pem}"
  ca_ecdsa_curve     = "${module.openvpn_server.ca_ecdsa_curve}"
  ca_algorithm       = "${module.openvpn_server.ca_algorithm}"
  cert_client_name   = "workstation"
}

resource "local_file" "workstation_client_conf" {
  content  = "${module.openvpn_client_workstation.client_config}"
  filename = "${path.module}/workstation.ovpn"
}
```

