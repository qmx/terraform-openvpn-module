output "server_cidr" {
  value = "${var.server_cidr}"
}

output "server_config" {
  value = "${data.template_file.ovpn_server_config.rendered}"
}

output "client_config" {
  value = "${data.template_file.ovpn_client_config.rendered}"
}
