terraform {
  backend "azurerm" {
    key                  = "EXAMPLE/qa/author/terraform.tfstate"
    storage_account_name = "storageacct"
    container_name       = "terraform-state"
    access_key           = "111111111111111111111111111111111111111111111111111111111111111111111"
  }
}
