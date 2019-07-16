# variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
# variable "tenant_id" {}
# variable "storage_access_key" {}
variable "backend" {}
variable "storage_account_name" {}
variable "container_name" {}

variable "site_dnsname" {}
variable "os_user" {}
variable "ssh_private_key_location" {}
variable "region" {}
variable "environment" {}
variable "tags" {
  default = {}
}
variable "author" {
  type = "map"
  default = {}
}

variable "publish" {
  type = "map"
}

variable "dispatch" {
  type = "map"
}
