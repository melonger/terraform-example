module "configurations_boostrap" {
  source                      = "../../modules/tf-config"
  disppriv_ips                = "${data.terraform_remote_state.disp.server_priv_ips}"
  pub_ips                     = "${data.terraform_remote_state.pub.server_pub_ips}"
  disp_ips                    = "${data.terraform_remote_state.disp.server_pub_ips}"
  auth_ips                    = "${data.terraform_remote_state.auth.server_pub_ips}"
  pubpriv_ips                 = "${data.terraform_remote_state.pub.server_priv_ips}"
  pub_count                   = "${var.publish["count"]}"
  auth_count                  = "${var.author["count"]}"
  site_dnsname                = "${var.site_dnsname}"
  os_user                     = "${var.os_user}"
  ssh_private_key_location    = "${var.ssh_private_key_location}"
  region                      = "${var.region}"
  environment                 = "${var.environment}"
  tags                        = "${var.tags}"
  depends_list                = "" #comma separated values. Would put status variables to pull from remote state files for nodes
}
