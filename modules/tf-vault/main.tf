resource "random_integer" "random" {
  min = 1
  max = 1000
}

resource "azurerm_key_vault" "main" {
  name                = "${var.azurename_prefix}-keyvault-${random_integer.random.result}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"

  sku_name = "${var.serverinfo["storage_sku"]}"

  tenant_id = "${var.tenant_id}"

  enabled_for_disk_encryption = "${var.serverinfo["disk_encryption_enabled"]}"

  tags {
     role         = "${var.serverinfo["role"]}"
     client       = "${var.tags["client"]}"
     environment  = "${var.environment}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}
