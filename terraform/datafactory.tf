resource "azurerm_data_factory" "example" {
  name                = "adf-iqsr-ae-${var.env}-001"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}