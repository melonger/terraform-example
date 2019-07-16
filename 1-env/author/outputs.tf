output "server_pub_ips" {
  value = "${module.author.servers_pubip_address}"
}

output "server_priv_ips" {
  value = "${module.author.servers_privip_address}"
}

output "server_names" {
  value = "${module.author.server_names}"
}

output "server_ids" {
  value = "${module.author.server_ids}"
}

output "server_status" {
  value = "${module.author.status}"
}

output "nsg_author_id" {
  value = "${module.sg_author.nsg_author_id}"
}
