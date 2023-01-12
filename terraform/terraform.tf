terraform {
  required_version = "1.3.7"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.38.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.31.0"
    }
  }

  backend "azurerm" {}
}