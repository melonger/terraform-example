terraform {
  backend "azurerm" {
    key                  = "DOUXEAMPLE/setup/terraform.tfstate"
    storage_account_name = "digitalonusstorage"
    container_name       = "terraform-state"
  }
}
