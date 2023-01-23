resource "azurerm_user_assigned_identity" "user1" {
  location            = data.azurerm_resource_group.rg.location
  name                = "uai-user1-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "user2" {
  location            = data.azurerm_resource_group.rg.location
  name                = "uai-uniting-iqsr-ae-user2-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_data_factory" "example" {
  name                = "adf-iqsr-ae-${var.env}-001"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user1.id,
      azurerm_user_assigned_identity.user2.id,
    ]
  }

  global_parameter {
    name  = "gp1"
    type  = "Bool"
    value = "false"
  }

  global_parameter {
    name  = "gp2"
    type  = "Bool"
    value = "false"
  }

   vsts_configuration {
     account_name    = "leriksen"
     branch_name     = var.env
     project_name    = "datascience"
     repository_name = "datascience"
     root_folder     = "/"
     tenant_id       = data.azurerm_client_config.current.tenant_id
   }
}
