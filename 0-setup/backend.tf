terraform {
  backend "azurerm" {
    key                  = "DOUEAMPLE/setup/terraform.tfstate"
    storage_account_name = "digitalonusstorage"
    container_name       = "terraform-state"
  }
}
