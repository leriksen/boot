data "azurerm_resource_group" "rg" {
  name = "rg-iqsr-${var.env}"
}