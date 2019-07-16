output "server_pub_ips" {
  value = "${module.dispatch.servers_pubip_address}"
}

output "server_priv_ips" {
  value = "${module.dispatch.servers_privip_address}"
}

output "server_names" {
  value = "${module.dispatch.server_names}"
}

output "server_ids" {
  value = "${module.dispatch.server_ids}"
}

output "server_pubip_id" {
  value = "${module.dispatch.server_pubip_id}"
}

output "server_status" {
  value = "${module.dispatch.status}"
}

output "lb_ip" {
  value = "${module.lb.lb_ip_address}"
}

output "lb_id" {
  value = "${module.lb.lb_id}"
}

output "nsg_dispatch_id" {
  value = "${module.sg_dispatch.nsg_dispatch_id}"
}
