terraform {
  backend "azurerm" {
    key                  = "DOUEXAMPLE/qa/author/terraform.tfstate"
    storage_account_name = "digitalonusstorage"
    container_name       = "terraform-state"
  }
}
