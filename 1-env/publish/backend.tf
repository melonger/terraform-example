terraform {
  backend "azurerm" {
    key                  = "DOUEAMPLE/qa/publish/terraform.tfstate"
    storage_account_name = "digitalonusstorage"
    container_name       = "terraform-state"
  }
}
