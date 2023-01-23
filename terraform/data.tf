data "azurerm_resource_group" "rg" {
  name = "rg-iqsr-${var.env}"
}

data "azurerm_client_config" "current" {}