resource "azurerm_key_vault_access_policy" "spi" {
  key_vault_id         = "${azurerm_key_vault.main.id}"

  tenant_id = "${var.tenant_id}"
  object_id = "${var.client_id}"

  key_permissions = [
    "create",
    "get",
    "list",
  ]

  secret_permissions = [
    "set",
    "get",
    "delete",
    "list",
  ]

}
