module "sg_author" {
  source                = "../../modules/tf-sg/author"
  tags                  = "${var.tags}"
  region                = "${var.region}"
  environment           = "${var.environment}"
  SG_Name               = "${lower(var.tags["client"])}-${var.author["role"]}-nsg"
  resource_group_name   = "${upper(var.tags["client"])}-RG"
  # serverinfo            = "${var.author}"
  mgmt_subnets          = "${var.mgmt_subnets}"
}

module "author" {
  source                      = "../../modules/tf-createinstance"
  ssh_public_key              = "${file(var.ssh_public_key_location)}"
  subnet_id                   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.tags["client"]}-RG/providers/Microsoft.Network/virtualNetworks/${lower(var.tags["client"])}-network/subnets/vnet${var.environment}"
  network_security_group_id   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.tags["client"]}-RG/providers/Microsoft.Network/networkSecurityGroups/${lower(var.tags["client"])}-${var.author["role"]}-nsg"
  azurename_prefix            = "${lower(var.tags["client"])}${var.environment}"
  hostname                    = "${lower(var.tags["client"])}-${var.environment}${var.author["name_suffix"]}-srv"
  region                      = "${var.region}"
  serverscount                = "${var.author["count"]}"
  environment                 = "${var.environment}"
  os_user                     = "${var.os_user}"
  resource_group_name         = "${upper(var.tags["client"])}-RG"
  network_security_group_name = "${lower(var.tags["client"])}-${var.author["name_suffix"]}-nsg"
  network_resource_group_name = "${lower(var.tags["client"])}-network"
  tags                        = "${var.tags}"
  serverinfo                  = "${var.author}"
}

module "author_boostrap" {
  source                      = "../../modules/tf-linux"
  ssh_private_key             = "${var.ssh_private_key_location}"
  ssh_public_key              = "${var.ssh_public_key_location}"
  pub_ips                     = "${module.author.servers_pubip_address}"
  storageacct                 = "${var.storage_account_name}"
  os_user                     = "${var.os_user}"
  chef_project                = "${var.chef_project}"
  serverscount                = "${var.author["count"]}"
  role                        = "${var.author["role"]}"
  region                      = "${var.region}"
  environment                 = "${var.environment}"
  tags                        = "${var.tags}"
  serverinfo                  = "${var.author}"
}
