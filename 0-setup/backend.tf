terraform {
  backend "azurerm" {
    key                  = "DOUEXAMPLE/setup/terraform.tfstate"
    storage_account_name = "digitalonusstorage"
    container_name       = "terraform-state"
  }
}
