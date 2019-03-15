module "publish" {
  source                      = "../../modules/tf-createinstance"
  ssh_public_key              = "../../datafiles/id_rsa.pub"
  subnet_id                   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.tags["client"]}-RG/providers/Microsoft.Network/virtualNetworks/${var.tags["client_lc"]}-network/subnets/vnet${var.environment}"
  network_security_group_id   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.tags["client"]}-RG/providers/Microsoft.Network/networkSecurityGroups/${var.tags["client_lc"]}-${var.publish["role"]}-nsg"
  azurename_prefix            = "${var.tags["client_lc"]}${var.environment}"
  hostname                    = "${var.tags["client_lc"]}-${var.environment}${var.publish["role"]}-srv"
  region                      = "${var.region}"
  serverscount                = "${var.publish["count"]}"
  environment                 = "${var.environment}"
  os_user                     = "${var.os_user}"
  resource_group_name         = "${var.tags["client"]}-RG"
  network_security_group_name = "${var.tags["client_lc"]}-${var.publish["role"]}-nsg"
  network_resource_group_name = "${var.tags["client_lc"]}-network"
  tags                        = "${var.tags}"
  serverinfo                  = "${var.publish}"
}

module "publish_boostrap" {
  source                      = "../../modules/tf-linux"
  user_data                   = "../../scripts/linux-common.sh"
  ssh_private_key             = "../../datafiles/id_rsa"
  pub_ips                     = "${module.publish.servers_pubip_address}"
  os_user                     = "${var.os_user}"
  chef_project                = "${var.chef_project}"
  serverscount                = "${var.publish["count"]}"
  role                        = "${var.publish["role"]}"
  region                      = "${var.region}"
  environment                 = "${var.environment}"
  tags                        = "${var.tags}"
  serverinfo                  = "${var.publish}"
  # chef_runlist                 = "chef-client -E ${var.environment} -o role[publish]"
  # depends_list                 = ""
}
