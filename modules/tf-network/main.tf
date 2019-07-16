resource "azurerm_virtual_network" "network" {
  name                = "${lower(var.tags["client"])}-network"
  location            = "${var.region}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${var.resource_group_name}"
  dns_servers         = "${var.dns_servers}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "subnet" {
  count                 = "${length(var.subnet_ids)}"
  name                  = "${element(var.subnet_names, count.index)}"
  virtual_network_name  = "${azurerm_virtual_network.network.name}"
  resource_group_name   = "${var.resource_group_name}"
  address_prefix        = "${element(var.subnet_ids, count.index)}/24"
}
