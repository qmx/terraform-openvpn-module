output "client_config" {
  value = "${data.template_file.ovpn_client_config.rendered}"
}
