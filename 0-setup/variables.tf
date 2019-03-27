# variable "subscription_id" {}
variable "client_id" {}
# variable "client_secret" {}
variable "tenant_id" {}
# variable "storage_access_key" {}
variable "backend" {}
variable "storage_account_name" {}
variable "container_name" {}

variable "environment" {}
variable "region" {}

variable "sku" {}
variable "retention_in_days" {}

# variable "ressourcegroupname" {}
variable "os_user" {}
# variable "ssh_public_key_location" {}
# variable "ssh_private_key_location" {}
variable "subnet_suffix" {}
variable "address_space" {}
variable "dns_servers" {
  type = "list"
}
variable "mgmt_subnets" {
  type = "list"
}
variable depends_on {
  default = [],
  type = "list"
}

variable "tags" {
  type = "map"
}
variable "subnet_ids" {
  type = "list"
}
variable "subnet_names" {
  type = "list"
}
variable "storage" {
  default = {
    storage_managed_disk_type          = "Premium_LRS"
    storage_account_tier               = "Standard"
    storage_account_replication_type   = "LRS"
    role                               = "storage"
    count                              = 1
    startindex                         = 0
  }
}

variable "vault" {
  type = "map"
  default = {
    storage_sku                        = "standard" # standard or premium
    role                               = "vault"
    disk_encryption_enabled            = true
  }
}

variable "backupvault" {
  type = "map"
  default = {
    timezone                          = "Eastern Standard Time"
    dailyretention                     = 5 # in days
    monthlyretention                   = 12 # in days
    backuptime                         = "11:00 PM"
  }
}

variable "publish" {
  default = {
    storage_publisher           = "Canonical"
    storage_offer               = "UbuntuServer"
    storage_sku                 = "16.04.0-LTS"
    storage_version             = "latest"
    storage_name                = "myOsDisk"
    storage_caching             = "ReadWrite"
    storage_create_option       = "FromImage"
    storage_managed_disk_type   = "Premium_LRS"
    role                        = "PUBLISH"
    count                       = 1
    size                        = "Standard_DS1_v2"
    startindex                  = 0
  }
}

variable "author" {
  default = {
    storage_publisher           = "Canonical"
    storage_offer               = "UbuntuServer"
    storage_sku                 = "16.04.0-LTS"
    storage_version             = "latest"
    storage_name                = "myOsDisk"
    storage_caching             = "ReadWrite"
    storage_create_option       = "FromImage"
    storage_managed_disk_type   = "Premium_LRS"
    role                        = "AUTHOR"
    count                       = 1
    size                        = "Standard_DS1_v2"
    startindex                  = 0
  }
}

variable "dispatch" {
  default = {
    storage_publisher           = "Canonical"
    storage_offer               = "UbuntuServer"
    storage_sku                 = "16.04.0-LTS"
    storage_version             = "latest"
    storage_name                = "myOsDisk"
    storage_caching             = "ReadWrite"
    storage_create_option       = "FromImage"
    storage_managed_disk_type   = "Premium_LRS"
    role                        = "DISPATCH"
    count                       = 1
    size                        = "Standard_DS1_v2"
    startindex                  = 0
  }
}
