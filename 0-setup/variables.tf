variable "client_id" {
  description = ""
}

variable "tenant_id" {}

variable "backend" {
  description = "Backend for all Terraform resources"
  default     = "azurerm"
}

variable "storage_account_name" {
  default = "examplestorage"
}

variable "container_name" {
  default = "terraform-state"
}

variable "environment" {
  default = "setup"
}

variable "region" {
  default = "canadacentral"
}

variable "os_user" {
  default = "azureuser"
}

variable "address_space" {
  default = "172.21.0.0/16"
}

variable "dns_servers" {
  type = "list"

  default = [
    "1.1.1.1",
    "1.0.0.1",
  ]
}

variable "mgmt_subnets" {
  type = "list"

  default = [
    "172.21.1.0/24",
    "172.21.2.0/24"
  ]
}

variable "tags" {
  type = "map"
  default = {
    client                  = "EXAMPLE"
    costcenter              = "ClientName"
  }
}

variable "subnet_ids" {
  type = "list"

  default = [
    "172.21.1.0",
    "172.21.2.0",
  ]
}

variable "subnet_names" {
  type = "list"

  default = [
    "vnetmgmt",
    "vnetqa",
    "vnetstage",
    "vnetprod",
  ]
}

variable "storage" {
  default = {
    storage_managed_disk_type        = "Premium_LRS"
    storage_account_tier             = "Standard"
    storage_account_replication_type = "LRS"
    role                             = "storage"
    count                            = 1
    startindex                       = 0
  }
}

variable "vault" {
  type = "map"

  default = {
    storage_sku             = "standard" # standard or premium
    role                    = "vault"
    disk_encryption_enabled = true
  }
}

variable "backupvault" {
  type = "map"

  default = {
    timezone         = "Eastern Standard Time"
    dailyretention   = 7                       # in days
    weeklyyretention = 4                       # in days
    monthlyretention = 3                       # in days
    backuptime       = "23:00"
  }
}

variable "depends_on" {
  default = []
  type    = "list"
}
