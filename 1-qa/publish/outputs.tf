output "server_pub_ips" {
  value = "${module.publish.servers_pubip_address}"
}

output "server_priv_ips" {
  value = "${module.publish.servers_privip_address}"
}

output "server_names" {
  value = "${module.publish.server_names}"
}

output "server_ids" {
  value = "${module.publish.server_ids}"
}

output "server_status" {
  value = "${module.publish.status}"
}

output "nsg_publish_id" {
  value = "${module.sg_publish.nsg_publish_id}"
}
