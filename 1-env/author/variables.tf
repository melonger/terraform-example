variable "subscription_id" {}

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
  default = "dev"
}

variable "region" {
  default = "canadacentral"
}

variable "os_user" {
  default = "azureuser"
}

variable "chef_project" {
  default = "project-base"
}

variable "ssh_private_key_location" {
  default = "../../varfiles/id_rsa"
}

variable "ssh_public_key_location" {
  default = "../../varfiles/id_rsa.pub"
}

variable "tags" {
  type = "map"
  default = {
    client                  = "EXAMPLE"
    costcenter              = "ClientName"
  }
}

variable "author" {
  type = "map"
  default = {}
}

variable "mgmt_subnets" {
  type = "list"

  default = [
    "172.21.1.0/24",
    "172.21.2.0/24"
  ]
}
