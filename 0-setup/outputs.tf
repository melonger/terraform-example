output "rg_name" {
  value = "${azurerm_resource_group.main.id}"
}

output "vnet_id" {
  value = "${module.network.vnet_id}"
}

output "vnet_address_space" {
  value = "${module.network.vnet_address_space}"
}

output "vnet_subnets" {
  value = "${module.network.vnet_subnets}"
}

output "nsg_author_id" {
  value = "${module.sg_author.nsg_author_id}"
}

output "nsg_dispatch_id" {
  value = "${module.sg_dispatch.nsg_dispatch_id}"
}

output "nsg_publish_id" {
  value = "${module.sg_publish.nsg_publish_id}"
}

output "storageacct_id" {
  value = "${module.storage.storageacct_id}"
}

output "storageacct_primary_blob_endpoint" {
  value = "${module.storage.storageacct_primary_blob_endpoint}"
}

output "storageacct_name" {
  value = "${module.storage.storageacct_name}"
}

output "keyvault_name" {
  value = "${module.vault.keyvault_name}"
}

output "keyvault_id" {
  value = "${module.vault.keyvault_id}"
}

output "backup_vault_id" {
  value = "${module.backupvault.backup_vault_id}"
}

output "backup_vault_name" {
  value = "${module.backupvault.backup_vault_name}"
}
