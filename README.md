# terraform-openvpn-module

A quick-and-dirty way of spinning up OpenVPN configuration files with a
throwaway CA structure.

This way you won't need to deal with easyrsa3 et al, and terraform will take
care of rotating the certificates for you.

## usage

```terraform
module "openvpn" {
  source       = "github.com/qmx/terraform-openvpn-module"
  vpn_endpoint = "localhost"
  vpn_port     = "31194"
  server_cidr  = "10.23.0.0/29"
  pod_cidr     = "10.22.44.0/24"
  svc_cidr     = "10.96.0.0/16"
}


output "ovpn_client_config" {
  value = "${module.openvpn.client_config}"
}
```

