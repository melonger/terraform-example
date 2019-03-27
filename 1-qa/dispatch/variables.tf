variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
# variable "tenant_id" {}
# variable "storage_access_key" {}
variable "backend" {}
variable "storage_account_name" {}
variable "container_name" {}

variable "region" {}
variable "environment" {}
variable "os_user" {}
variable "chef_project" {}
variable "ssh_private_key_location" {}
variable "ssh_public_key_location" {}

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

variable "monitor_cpu" {
  type = "map"
  default = {}
}

variable "monitor_storage" {
  type = "map"
  default = {}
}

variable "tracked_url" {}
