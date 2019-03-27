variable "tags" {
  type = "map"
}

variable "serverinfo" {
  type = "map"
}
variable "user_data" {}
variable "aem_data" {}
variable "region" {}
variable "serverscount" {}
variable "environment" {}
variable "pub_ips" {
  type = "list"
}
variable "os_user" {}
variable "ssh_private_key" {}
variable "ssh_public_key" {}
variable "storageacct" {}
variable "role" {}
variable "chef_project" {}
