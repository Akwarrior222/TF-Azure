provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform-state"                      # Replace with your actual resource group
    storage_account_name  = "skcnterraformstate"                      # Must be globally unique
    container_name        = "tfstate"                                 # Azure Blob Container
    key                   = "base-infra/nonprod.terraform.tfstate"    # State file path
  }
}
