resource "azurerm_data_factory" "example" {
  name                = "adf-iqsr-ae-${var.env}-001"
  location            = data.rg.location
  resource_group_name = data.rg.name
}